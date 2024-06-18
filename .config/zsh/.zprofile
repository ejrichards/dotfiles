function _addpath {
	case ":${PATH}:" in
		*:"$1":*)
			;;
		*)
			PATH="$1:$PATH"
			;;
	esac
}
function _removepath {
	PATH=:$PATH:
	PATH=${PATH//:$1:/:}
	PATH=${PATH#:}; PATH=${PATH%:}
}

if [ -d "/opt/gradle" ]; then
	_addpath "/opt/gradle"
fi

if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi

if [ -d "$HOME/.local/bin" ]; then
	_addpath "$HOME/.local/bin"
fi

if [ -d "$HOME/.bun" ]; then
	export BUN_INSTALL="$HOME/.bun"
	_addpath "$BUN_INSTALL/bin"
fi

if [ -f "$HOME/.badpath" ]; then
	. "$HOME/.badpath"
fi

if [ -d "/mnt/c/Program Files/WezTerm" ]; then
	_addpath "/mnt/c/Program Files/WezTerm"
fi

# In Windows: WSLENV=LOCALAPPDATA/up
if [[ -n "$LOCALAPPDATA" ]]; then
	if [ -d "$LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe" ]; then
		_addpath "$LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe"
	fi

	if [ -d "$LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.WindowsTerminal_8wekyb3d8bbwe" ]; then
		_addpath "$LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.WindowsTerminal_8wekyb3d8bbwe"
	fi
fi
