$script:lastPath = $null

function __autoenv_getVenvDir {
	[CmdletBinding()]
	param ($dir)

	$venvdir = $null
	while ($dir) {
		$venv = Join-Path -Path (Get-Item $dir -Force) -ChildPath '.venv'
		if (Test-Path $venv) {
			return $venv
		}
		$dir = (Get-Item $dir -Force).parent
	}

	return $null
}

function __autovenv {
	if ($script:lastPath -eq $null -or $script:lastPath -ne $pwd) {
		$script:lastPath = $pwd

		$venvdir = __autoenv_getVenvDir $pwd
		if ($venvdir -ne $env:VIRTUAL_ENV) {
			if ($venvdir) {
				Write-Host "Activating $venvdir" -ForegroundColor 'green'
				. (Join-Path -Path $venvdir -ChildPath 'Scripts\Activate.ps1')
			} else {
				Write-Host "Deactivating venv" -ForegroundColor 'green'
				deactivate
			}
		}
	}
}
