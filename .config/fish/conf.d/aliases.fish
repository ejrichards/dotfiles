if status is-interactive
	if command -q eza
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

	if command -q bat
		alias cat='bat'
	else if command -q batcat
		alias cat='batcat'
		alias bat='batcat'
	end

	if command -q fdfind
		alias fd='fdfind'
	end

	if command -q rage
		alias age='rage'
	end

	if command -q systemctl
		abbr --add ctl systemctl
		abbr --add ctlu systemctl --user
		abbr --add sctl sudo systemctl
		abbr --add jctl journalctl
		abbr --add sjctl sudo journalctl
	end

	if command -q yazi
		function y
			set tmp (mktemp -t "yazi-cwd.XXXXXX")
			yazi $argv --cwd-file="$tmp"
			if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
				builtin cd -- "$cwd"
			end
			rm -f -- "$tmp"
		end
	end

	alias which='type'

	abbr --add gs git status
	abbr --add gsh git show
	abbr --add gd git diff
	abbr --add gds git diff --staged
	abbr --add gl git log
	abbr --add gc git commit -m
	abbr --add gca git commit -am
	abbr --add gdt git difftool

	alias echopath='printf \'%s\n\' $PATH'

	alias dot="git --git-dir=$HOME/.dotgit/ --work-tree=$HOME"

	alias ssha='ssh -o User=ubuntu -o IdentityAgent=none -o IdentityFile=/dev/null -o IdentitiesOnly=yes -o PubkeyAuthentication=no'

	alias vim='nvim'

	if command -q aerc
		function aerc
			set cert ~/.local/share/certs/protonbridge.pem
			if not test -f $cert
				echo 'Missing cert '$cert
				return 1
			end

			SSL_CERT_FILE=$cert command aerc $argv
		end
	end

	if command -q newsboat
		function news
			newsboat
			newsboat -x print-unread > ~/.local/state/newsboat-unread
			pkill --signal 35 waybar
		end
	end

	if command -q nvd
		function nvd-latest
			set gens (nixos-rebuild list-generations --json | jq -r '.[0].generation, .[1].generation')
			nvd diff /nix/var/nix/profiles/system-{$gens[1],$gens[2]}-link
		end
	end
end
