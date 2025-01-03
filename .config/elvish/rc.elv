use os
use path
use platform

# Local modules
use env
use ls-colors
use wsl

if (not (os:is-dir /etc/nixos)) {
	use epm
	epm:install &silent-if-installed=$true github.com/ejrichards/mellon
}

set notify-bg-job-success = $false

set edit:completion:matcher[argument] = {|seed| edit:match-prefix $seed &ignore-case=$true }

set edit:insert:binding[Shift-Backspace] = { edit:kill-rune-left }
set edit:insert:binding[Ctrl-Backspace] = { edit:kill-small-word-left }
set edit:insert:binding[Ctrl-h] = { edit:kill-small-word-left }

set edit:insert:binding[Ctrl-p] = { edit:history:start }
set edit:insert:binding[Ctrl-n] = { nop }
set edit:insert:binding[Enter] = {
	if (has-key $edit:command-abbr $edit:current-command) {
		edit:replace-input $edit:command-abbr[$edit:current-command]
	}
	edit:smart-enter
}
set edit:insert:binding[Shift-Enter] = { edit:insert-at-dot "\n" }

set edit:history:binding[Ctrl-p] = { edit:history:up }
set edit:history:binding[Ctrl-n] = { edit:history:down-or-quit }

set edit:completion:binding[Ctrl-p] = { edit:completion:up-cycle }
set edit:completion:binding[Ctrl-n] = { edit:completion:down-cycle }
set edit:completion:binding[Ctrl-y] = { edit:completion:accept }
set edit:completion:binding[Enter] = { edit:completion:accept; edit:return-line }

if (has-external mise) {
	var mise: = (ns [&])
	eval (mise activate elvish | slurp) &ns=$mise: &on-end={|ns| set mise: = $ns }
	edit:add-var mise~ {|@args| mise:mise $@args }

	mise:activate
}

if (has-external starship) {
	eval (starship init elvish)
}

if (has-external zoxide) {
	eval (zoxide init elvish --cmd cd | slurp)
}

if (has-external carapace) {
	eval (carapace _carapace elvish | slurp)
}

use aliases

if (has-external atuin) {
	use github.com/ejrichards/mellon/atuin
	set edit:insert:binding[Ctrl-r] = { atuin:search }
	set edit:insert:binding[Up] = { atuin:search-up }
} elif (has-external fzf) {
	use github.com/ejrichards/mellon/fzf
	set edit:insert:binding[Ctrl-r] = { fzf:history --border=rounded --no-mouse --exact }
	set edit:insert:binding[Up] = { fzf:history --border=rounded --no-mouse --exact }
}

var hostname
if (not-eq $E:WSL_DISTRO_NAME '') {
	set hostname = $E:WSL_DISTRO_NAME
	if (eq $hostname 'Ubuntu') {
		set hostname = ' '
	} elif (eq $hostname 'NixOS') {
		set hostname = ' '
	} elif (eq $hostname 'Debian') {
		set hostname = ' '
	} else {
		set hostname = $hostname'│'
	}
} else {
	set hostname = (platform:hostname)'│'
}
set edit:before-readline = [$@edit:before-readline {
	var dirname
	if (eq $pwd ~) {
		set dirname = '~'
	} else {
		set dirname = (path:base $pwd)
	}
	# Title
	print "\e]0;"$hostname$dirname"\007"

	# 1 = Blinking Block, 2 = Solid Block
	# Moved to WezTerm config
	# print "\e[1 q"
}]

if (has-external fastfetch) {
	fastfetch --logo ~/.config/fastfetch/elvish.txt --logo-type file --logo-color-1 white --logo-color-2 green
}
