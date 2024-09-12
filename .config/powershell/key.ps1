function key {
	[CmdletBinding()]
	param ($action, $keyname, $varname)

	$dir = "$env:LOCALAPPDATA\ejrichards\keys"

	if ($action -eq 'add') {
		if (!$keyname) {
			echo 'Usage: key add <key_name>'
		}
		$path = "$dir\$keyname.age"
		if (Test-Path -path $path) {
			echo "key file '$keyname' already exists"
			return
		}
		$key = Read-Host 'Enter key' -MaskInput
		if (!$key) {
			echo 'Aborting'
		}

		echo $key | age -R $HOME\.age\recipients.txt -o "$path" -
	} elseif ($action -eq 'use') {
		if (!$keyname) {
			echo 'Usage: key use <key_name> <var_name>'
		}
		$path = "$dir\$keyname.age"
		if (-Not (Test-Path -path $path)) {
			echo "no key file '$keyname'"
			return
		}
		if (!$varname) {
			$varname = $keyname
		}
		age --decrypt -i $HOME\.age\identities.txt "$path" | Set-Item env:$varname
	} elseif ($action -eq 'list') {
		Get-ChildItem -Path "$dir" | Select-Object -ExpandProperty BaseName
	} else {
		echo 'Commands: add, list, use'
	}
}
