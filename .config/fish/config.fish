# This file is LAST
set -g fish_greeting ""

if status is-interactive
	# man coloring
	set -gx MANROFFOPT '-c'
	set -gx MANPAGER 'less -R --use-color -Dd+g -Du+b'

	bind \b backward-kill-word
	bind -k nul forward-char
	bind \cz fancy_ctrl_z


	if command -v lc &> /dev/null
		function __cd_ls --on-variable PWD
			lc 50 && ls || echo 'Too many files...'
		end
	else
		function __cd_ls --on-variable PWD
			ls
		end
	end

	if command -v mise &> /dev/null
		mise activate fish | source
	end

	if command -v fzf &> /dev/null
		fzf --fish | source
	end
	if command -v atuin &> /dev/null
		atuin init fish | source
	end
	if command -v starship &> /dev/null
		starship init fish | source
	end
end
