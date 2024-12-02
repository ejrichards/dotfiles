if status is-interactive
	if command -v eza &> /dev/null
		alias eza='eza --group-directories-first --color=auto --time-style=relative'
		alias ls='eza --icons=auto'
		alias ll='eza -lahF --icons=auto --git'
		alias la='eza -a --icons=auto'
		alias l='eza -F'
	else
		export QUOTING_STYLE=literal
		alias ll='ls -alFh'
		alias la='ls -A'
		alias l='ls -CF'
		alias lq='ls --quoting-style=shell-escape'
		alias ls='ls --group-directories-first --color=auto'
	end

	if command -v bat &> /dev/null
		alias cat='bat'
	else if command -v batcat &> /dev/null
		alias cat='batcat'
		alias bat='batcat'
	end

	if command -v fdfind &> /dev/null
		alias fd='fdfind'
	end

	if command -v rage &> /dev/null
		alias age='rage'
	end

	if command -v systemctl &> /dev/null
		alias ctl='systemctl'
		alias sctl='sudo systemctl'
	end

	if command -v yazi &> /dev/null
		alias y='yazi'
	end

	alias which='type'

	alias gs='git status'
	alias gsh='git show'
	alias gd='git diff'
	alias gl='git log'
	alias gc='git commit -m'
	alias gca='git commit -am'
	alias gdt='git difftool'

	alias echopath='echo $PATH | tr " " "\n"'

	alias dot="git --git-dir=$HOME/.dotgit/ --work-tree=$HOME"

	alias ssha='ssh -o User=ubuntu -o IdentityAgent=none -o IdentityFile=/dev/null -o IdentitiesOnly=yes -o PubkeyAuthentication=no'

	alias vim='nvim'
end
