set -g fish_greeting ""

if status is-interactive
	bind \b backward-kill-word
	bind -k nul forward-char

	if command -v atuin &> /dev/null
		atuin init fish | source
	end
	if command -v starship &> /dev/null
		starship init fish | source
	end
end
