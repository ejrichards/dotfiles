# This file is LAST
set -g fish_greeting ""

if status is-interactive
	set -U fish_color_command green
	set -U fish_color_param white

	set fish_cursor_default block
	set fish_cursor_external line

	# man coloring
	set -gx MANROFFOPT '-c'
	set -gx MANPAGER 'less -R --use-color -Dd+g -Du+b'

	function __enter_override
		# Make enter execute the line rather than just accept
		if commandline --paging-mode
			commandline -f yank
		end
		commandline -f execute
	end
	bind enter __enter_override

	bind ctrl-backspace backward-kill-word
	bind ctrl-space accept-autosuggestion
	bind ctrl-z fancy_ctrl_z


	if command -q lc
		function __cd_ls --on-variable PWD
			lc 50 && ls || echo 'Too many files...'
		end
	else
		function __cd_ls --on-variable PWD
			ls
		end
	end

	if command -q mise
		mise activate fish | source
	end

	if command -q fzf
		fzf --fish | source
	end
	if command -q atuin
		atuin init fish | source
		# Fix until update
		bind up _atuin_bind_up
	end
	if command -q starship
		starship init fish | source
	end
	if command -q zoxide
		zoxide init fish --cmd cd | source
		bind ctrl-l 'cdi; commandline -f repaint'
	end

	if command -q fastfetch
		fastfetch --logo ~/.config/fastfetch/fish.txt --logo-type file
	end
end
