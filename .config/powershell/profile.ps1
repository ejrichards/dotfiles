# Add to "$HOME/Documents/PowerShell/profile.ps1" for pwsh 6+ on Windows
# . "$HOME/.config/powershell/profile.ps1"
Set-PSReadLineKeyHandler -Chord "Ctrl+Spacebar" -Function AcceptSuggestion

function fg-up([string]$file) {
	scp $file fgup:$(Split-Path -Path $pwd -Leaf)/
}
function backup([string]$file) {
	$backupFolder = if ($env:EJR_BACKUP) { $env:EJR_BACKUP } else { "$HOME\Documents\Backups\" };
	7z a -tzip "$backupFolder\$(Split-Path -Path $file -Leaf)-backup-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').zip" "$file"
}

Remove-Alias -Name diff -Force -ErrorAction SilentlyContinue

Remove-Alias -Name gc -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gcb -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gcm -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gcs -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gl -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gm -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gp -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gpv -Force -ErrorAction SilentlyContinue

function gs { git status $args }
function gsh { git show $args }
function gd { git diff $args }
function gl { git log $args }
function gc { git commit -m $args }
function gca { git commit -am $args }
function gdt { git difftool $args }

Set-Alias -Name which -Value Get-Command
Set-Alias -Name ip -Value Get-NetIPConfiguration
function ipp { Get-NetIPConfiguration -InterfaceAlias Ethernet -Detailed }
Set-Alias -Name vim -Value nvim
Set-Alias -Name cat -Value bat

. $HOME/.config/powershell/autovenv.ps1

if (Get-Command "starship.exe" -ErrorAction SilentlyContinue) {
	function Invoke-Starship-PreCommand {
		__autovenv
		$dirname = if ($pwd.Path -eq $HOME) { '~' } else { Split-Path -Path $pwd -Leaf }
		$host.ui.RawUI.WindowTitle = " $env:COMPUTERNAME`:$dirname`a"
	}
	Invoke-Expression (&starship init powershell)
}

if (Get-Command "rage.exe" -ErrorAction SilentlyContinue) {
	Set-Alias -Name age -Value rage
}

#Import-Module posh-git
#function prompt {
#	__autovenv
#
#	& $GitPromptScriptBlock
#}

function dot { git --git-dir=$HOME\.dotgit\ --work-tree=$HOME $args }

# winget install ajeetdsouza.zoxide
Remove-Alias -Name cd
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

Set-PSReadLineOption -Colors @{
	InlinePrediction = [ConsoleColor]::DarkGray
	Parameter = [ConsoleColor]::Blue 
}
