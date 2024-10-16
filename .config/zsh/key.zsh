function key {
	local verbose
	local positional_args=()
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-v | --verbose)
				verbose="true"
				shift
				;;
			-*)
				echo "Unknown option: $1"
				return 1
				;;
			*)
				positional_args+=("$1")
				shift
				;;
		esac
	done
	set -- $positional_args


	if [[ -z $EJR_KEYS  ]]; then
		echo "env var 'EJR_KEYS' not set"
		return 1
	fi
	if ! command -v age &> /dev/null; then
		echo "age not installed"
		return 1
	fi

	local dir=$EJR_KEYS
	local action
	local keyname
	local varname

	if [[ $# -ge 1 ]]; then
		action=$1
	fi
	if [[ $# -ge 2 ]]; then
		keyname=$2
	fi
	if [[ $# -ge 3 ]]; then
		varname=$3
	fi

	if [[ $action == 'add' ]]; then
		if [[ -z $keyname ]]; then
			echo 'Usage: key add <key_name>'
			return 1
		fi
		local filepath="$dir/$keyname.age"
		if [[ -e $filepath ]]; then
			echo "key file '$keyname' already exists"
			return 1
		fi
		echo -n "Enter key: "
		read -s key
		echo
		if [[ -z $key ]]; then
			echo 'Aborting'
			return 1
		fi

		echo $key | age -R ~/.age/recipients.txt -o "$filepath" -
	elif [[ $action == 'use' ]]; then
		if [[ -z $keyname ]]; then
			echo 'Usage: key use <key_name> <var_name>'
			return 1
		fi
		local filepath="$dir/$keyname.age"
		if [[ ! -e $filepath ]]; then
			echo "no key file '$keyname'"
			return 1
		fi
		if [[ -z $varname ]]; then
			varname=$keyname
		fi

		if [[ -n "${(P)varname}" ]]; then
			if [[ -n $verbose ]]; then
				echo "'$varname' is already set"
			fi
			return
		fi

		export ${varname}=$(age --decrypt -i ~/.age/identities.txt "$filepath")

		if [[ -n "${(P)varname}" ]]; then
			echo "'$varname' is set"
		else
			echo "Issue setting '$varname'"
		fi
	elif [[ $action == 'list' ]]; then
		basename --suffix='.age' $dir/*
	else
		echo 'Commands: add, list, use'
	fi
}
