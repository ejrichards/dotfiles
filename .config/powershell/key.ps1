function key {
	[CmdletBinding()]
	param (
		$action,
		$keyname,
		$varname,
		[switch]$v
	)

	if (-Not (Test-Path env:EJR_KEYS)) {
		echo "env var 'EJR_KEYS' not set"
		return
	}

	$dir = $env:EJR_KEYS

	if ($action -eq 'add') {
		if (!$keyname) {
			echo 'Usage: key add <key_name>'
			return
		}
		$filepath = "$dir\$keyname.age"
		if (Test-Path -path $filepath) {
			echo "key file '$keyname' already exists"
			return
		}
		$key = Read-Host 'Enter key' -MaskInput
		if (!$key) {
			echo 'Aborting'
			return
		}

		echo $key | age -R $HOME\.age\recipients.txt -o "$filepath" -
	} elseif ($action -eq 'use') {
		if (!$keyname) {
			echo 'Usage: key use <key_name> <var_name>'
			return
		}
		$filepath = "$dir\$keyname.age"
		if (-Not (Test-Path -path $filepath)) {
			echo "no key file '$keyname'"
			return
		}
		if (!$varname) {
			$varname = $keyname
		}

		if (Test-Path env:$varname) {
			if ($v) {
				echo "'$varname' is already set"
			}
			return
		}

		age --decrypt -i $HOME\.age\identities.txt "$filepath" | Set-Item env:$varname

		if (Test-Path env:$varname) {
			echo "`n'$varname' is set"
		} else {
			echo "`nIssue setting '$varname'"
		}
	} elseif ($action -eq 'list') {
		Get-ChildItem -Path "$dir" | Select-Object -ExpandProperty BaseName
	} else {
		echo 'Commands: add, list, use'
	}
}
