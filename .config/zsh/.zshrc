fpath=( ${ZDOTDIR:-~}/completions "${fpath[@]}" )

# Seems to be auto added now, needs trailing :
#MANPATH=~/.local/share/man:$MANPATH

WORDCHARS=${WORDCHARS/\/}

# Plugins
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

if command -v mise &> /dev/null; then
	eval "$(mise activate zsh)"
fi

bindkey '^ ' autosuggest-accept
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word

# From fancy-ctrl-z plugin
fancy-ctrl-z () {
	if [[ $#BUFFER -eq 0 ]]; then
		BUFFER="fg"
		zle accept-line -w
	fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Completion: case insensitive and partial match
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
# Without hyphens
# zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'

export EDITOR=nvim
alias vim='nvim'

# History
export HISTFILE=$ZDOTDIR/.histfile
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY # Don't execute immediately
setopt HIST_IGNORE_SPACE # Ignore if starts with space

# bash style prompt, %F color, 2=green, 10=bgreen, 4=blue, 12=bblue
# $ makes escape codes work, %{%} indicates no length, \e]0; \a set the title
# %-80(l|long|short) dynamic with line length
PS1=$'%{\e]0;%m:%1~\a%}%F{10}%n@%m%F{reset_color}%-80(l|:%F{12}%(5~|%-1~/…/%3~|%4~)|)%F{reset_color}%(!.#.$) '
RPROMPT='${GITSTATUS_PROMPT}'

# WSL
if [[ `uname -r` = *"microsoft"* ]]; then
	umask 022
	export SSH_SK_HELPER="/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe"
	
	function clip {
		if [ "$#" -eq 0 ]; then
			pwsh.exe -Command "Get-Clipboard"
		elif [ "$@" = "-" ]; then
			read input
			pwsh.exe -Command "Set-Clipboard '$input'"
		else
			pwsh.exe -Command "Set-Clipboard '$@'"
		fi
	}

	if [[ $- == *i* ]]; then
		# Solid block cursor to stop WSL from blinking
		echo -en '\e[2 q'
	fi
fi

# Aliases
source ~/.config/bash/bash_aliases

if command -v wslpath &> /dev/null; then
	function cdd {
		builtin cd $(wslpath -a "$@")
	}
fi

if command -v lc &> /dev/null; then
	function cd {
		builtin cd "$@" && (lc 50 && ls || echo 'Too many files...')
	}
else
	function cd {
		builtin cd "$@" && ls
	}
fi

function unln {
	if [[ $# -ne 1 ]]; then
		echo 'Needs 1 argument'
		return 0
	fi
	cp --remove-destination "$(readlink $1)" $1
}
