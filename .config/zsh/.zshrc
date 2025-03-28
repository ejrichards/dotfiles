fpath=( ${ZDOTDIR:-~}/completions "${fpath[@]}" )

# Seems to be auto added now, needs trailing :
#MANPATH=~/.local/share/man:$MANPATH

WORDCHARS=${WORDCHARS/\/}

# TODO: No way to disable ^R, so put before plugins
if command -v fzf &> /dev/null; then
	export FZF_COMPLETION_TRIGGER='~~'
	source <(fzf --zsh)
fi

# Plugins
if [ -d "${ZDOTDIR:-~}/.antidote" ]; then
	source ${ZDOTDIR:-~}/.antidote/antidote.zsh
	antidote load
fi

if command -v mise &> /dev/null; then
	eval "$(mise activate zsh)"
fi
if command -v atuin &> /dev/null; then
	source <(atuin init zsh)
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

# $ makes escape codes work, %{%} indicates no length, \e]0; \a set the title
function set_win_title(){
	print -nP $'\e]0;%m:%1~\a'
}
precmd_functions+=(set_win_title)

if command -v starship &> /dev/null; then
	eval "$(starship init zsh)"
else
	# bash style prompt, %F color, 2=green, 10=bgreen, 4=blue, 12=bblue
	# %-80(l|long|short) dynamic with line length
	PS1=$'%F{10}%n@%m%F{reset_color}%-80(l|:%F{12}%(5~|%-1~/…/%3~|%4~)|)%F{reset_color}%(!.#.$) '
	# RPROMPT='${GITSTATUS_PROMPT}'
fi

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
		function __reset_cursor() {
			echo -en '\e[2 q'
		}

		# Solid block cursor to stop WSL from blinking
		precmd_functions+=(__reset_cursor)
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

function completion-update { (
	set -e
	cd /tmp

	set -x

	# Man pages
	mkdir -p ~/.local/share/man/man1/
	mkdir -p ~/.local/share/man/man5/
	name=$(curl https://api.github.com/repos/eza-community/eza/releases/latest | jq --raw-output --exit-status '.assets[] | select(.name | contains("man-")) | .browser_download_url')
	curl -L --remote-name $name
	tar xvf man-*.tar.gz --directory=$HOME/.local/share/man/man1 --no-same-owner --strip-components 3 --no-anchored --wildcards "*.1"
	tar xvf man-*.tar.gz --directory=$HOME/.local/share/man/man5 --no-same-owner --strip-components 3 --no-anchored --wildcards "*.5"
	rm man-*.tar.gz

	wget https://raw.githubusercontent.com/jdx/mise/main/man/man1/mise.1 --directory-prefix $HOME/.local/share/man/man1/
	wget https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 --directory-prefix $HOME/.local/share/man/man1/
	rg --generate=man > $HOME/.local/share/man/man1/rg.1

	# Completions
	wget https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza -O ${ZDOTDIR:-~}/completions/_eza
	wget https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/zsh_tealdeer -O ${ZDOTDIR:-~}/completions/_tealdeer
	atuin gen-completions --shell zsh > ${ZDOTDIR:-~}/completions/_atuin
	mise completion zsh > ${ZDOTDIR:-~}/completions/_mise
	rg --generate=complete-zsh > ${ZDOTDIR:-~}/completions/_rg

	rm -f ~/.cache/zsh/compdump
	rm -rf ~/.cache/zsh/compcache
) }

if [ -f "${ZDOTDIR:-~}/key.zsh" ]; then
	source "${ZDOTDIR:-~}/key.zsh"
fi
