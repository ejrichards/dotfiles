use os
use path
use platform

set-env HOME ~

if (os:is-dir $E:XDG_CONFIG_HOME/elvish/bin) {
	set paths = [ $E:XDG_CONFIG_HOME/elvish/bin $@paths ]
}

if (not (os:is-dir /etc/nixos)) {
	use epm
	epm:install &silent-if-installed=$true github.com/ejrichards/mellon
}

set notify-bg-job-success = $false

set edit:completion:matcher[argument] = {|seed| edit:match-prefix $seed &ignore-case=$true }

set edit:insert:binding[Shift-Backspace] = { edit:kill-rune-left }
set edit:insert:binding[Ctrl-Backspace] = { edit:kill-small-word-left }
set edit:insert:binding[Ctrl-p] = { edit:history:start }
set edit:insert:binding[Ctrl-n] = { nop }

set edit:history:binding[Ctrl-p] = { edit:history:up }
set edit:history:binding[Ctrl-n] = { edit:history:down-or-quit }

set edit:completion:binding[Ctrl-p] = { edit:completion:up-cycle }
set edit:completion:binding[Ctrl-n] = { edit:completion:down-cycle }
set edit:completion:binding[Ctrl-y] = { edit:completion:accept }
set edit:completion:binding[Tab] = { edit:completion:accept }
set edit:completion:binding[Enter] = { edit:completion:accept; edit:return-line }

if (has-external mise) {
	var mise: = (ns [&])
	eval (mise activate elvish | slurp) &ns=$mise: &on-end={|ns| set mise: = $ns }
	edit:add-var mise~ {|@args| mise:mise $@args }

	mise:activate
}

if (has-external starship) {
	set-env STARSHIP_CONFIG ~/.config/starship-elv.toml
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
	use atuin
	set edit:insert:binding[Ctrl-r] = { atuin:search }
	set edit:insert:binding[Up] = { atuin:search-up }
} elif (has-external fzf) {
	use github.com/ejrichards/mellon/fzf
	set edit:insert:binding[Ctrl-r] = { fzf:history }
	set edit:insert:binding[Up] = { fzf:history }
}

set edit:before-readline = [$@edit:before-readline {
	var dirname
	if (eq $pwd ~) {
		set dirname = '~'
	} else {
		set dirname = (path:base $pwd)
	}
	print "\e]0;"(platform:hostname):$dirname"\007"
}]

