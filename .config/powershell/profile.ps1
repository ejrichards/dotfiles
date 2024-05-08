# Need to symlink this to "$HOME/Documents/PowerShell/profile.ps1" for pwsh 6+
Set-PSReadLineKeyHandler -Chord "Ctrl+Spacebar" -Function AcceptSuggestion

function fg-up([string]$file) {
	scp $file fgup:$(Split-Path -Path $pwd -Leaf)/
}
function backup([string]$file) {
	$backupFolder = if ($env:EJR_BACKUP) { $env:EJR_BACKUP } else { "$HOME\Documents\Backups\" };
	7z a -tzip "$backupFolder\$(Split-Path -Path $file -Leaf)-backup-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').zip" "$file"
}

If (Test-Path Alias:gc) {Remove-Item Alias:gc -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gcb) {Remove-Item Alias:gcb -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gcm) {Remove-Item Alias:gcm -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gcs) {Remove-Item Alias:gcs -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gl) {Remove-Item Alias:gl -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gm) {Remove-Item Alias:gm -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gp) {Remove-Item Alias:gp -Force -ErrorAction SilentlyContinue}
If (Test-Path Alias:gpv) {Remove-Item Alias:gpv -Force -ErrorAction SilentlyContinue}

function gs { git status $args }
function gsh { git show $args }
function gd { git diff $args }
function gl { git log $args }
function gc { git commit -m $args }
function gca { git commit -am $args }

Import-Module posh-git

function dot { git --git-dir=$HOME\.dotgit\ --work-tree=$HOME $args }
