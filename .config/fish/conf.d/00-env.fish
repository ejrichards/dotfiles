set -gx GOPATH $HOME/.local/share/go
set -gx BUN_INSTALL $HOME/.bun

fish_add_path -g \
	"$HOME/.local/bin" \
	"$BUN_INSTALL/bin" \
	"$HOME/.cargo/bin" \
	"/opt/gradle" \
	"/mnt/c/Program Files/WezTerm" \
	"/mnt/c/Program Files/PowerShell/7"

if set -q LOCALAPPDATA
	fish_add_path -g \
		"$LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.WindowsTerminal_8wekyb3d8bbwe" \
		"$LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe" \
		"$LOCALAPPDATA/wslpath"
end
