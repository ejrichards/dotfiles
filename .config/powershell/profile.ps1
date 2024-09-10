# Add to "$HOME/Documents/PowerShell/profile.ps1" for pwsh 6+ on Windows
# . "$HOME/.config/powershell/profile.ps1"
Set-PSReadLineKeyHandler -Chord "Ctrl+Spacebar" -Function AcceptSuggestion

function backup([string]$file) {
	$backupFolder = if ($env:EJR_BACKUP) { $env:EJR_BACKUP } else { "$HOME\Documents\Backups\" };
	7z a -tzip "$backupFolder\$(Split-Path -Path $file -Leaf)-backup-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').zip" "$file"
}

if (Get-Command "eza.exe" -ErrorAction SilentlyContinue) {
	$defargs = @("--group-directories-first", "--color=auto", "--time-style=relative")
	Remove-Alias -Name ls -Force -ErrorAction SilentlyContinue
	function ls { eza $defargs --icons=auto $args}
	function ll { eza $defargs --icons=auto --git -lahF $args}
	function la { eza $defargs --icons=auto -a $args}
	function l  { eza $defargs -F $args}
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

function gc { git commit -m $args }
function gca { git commit -am $args }
function gd { git diff $args }
function gdt { git difftool $args }
function gl { git log $args }
function gs { git status $args }
function gsh { git show $args }

Set-Alias -Name which -Value Get-Command
Set-Alias -Name ip -Value Get-NetIPConfiguration
function ipp { Get-NetIPConfiguration -InterfaceAlias Ethernet -Detailed }
Set-Alias -Name vim -Value nvim
Set-Alias -Name cat -Value bat

. $HOME/.config/powershell/autovenv.ps1

if (Get-Command "starship.exe" -ErrorAction SilentlyContinue) {
	$env:STARSHIP_CONFIG = "$HOME\.config\starship-pwsh.toml"
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

function dot { git --git-dir=$HOME\.dotgit\ --work-tree=$HOME $args }

# winget install ajeetdsouza.zoxide
if (Get-Command "zoxide.exe" -ErrorAction SilentlyContinue) {
	Remove-Alias -Name cd
	Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}

Set-PSReadLineOption -Colors @{
	InlinePrediction = [ConsoleColor]::DarkGray
	Parameter = [ConsoleColor]::Blue 
}

if (Get-Command "carapace.exe" -ErrorAction SilentlyContinue) {
	$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
	Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
	Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
	carapace _carapace | Out-String | Invoke-Expression
}
