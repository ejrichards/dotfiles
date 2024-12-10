use os

set-env HOME ~

if (os:is-dir $E:XDG_CONFIG_HOME/elvish/bin) {
	set paths = [ $E:XDG_CONFIG_HOME/elvish/bin $@paths ]
}

# Tab completion smart-case
set edit:completion:matcher[argument] = {|seed| edit:match-prefix $seed &smart-case=$true }

set edit:insert:binding[Ctrl-p] = { edit:history:start }
set edit:history:binding[Ctrl-p] = { edit:history:up }
set edit:insert:binding[Ctrl-n] = { nop }
set edit:history:binding[Ctrl-n] = { edit:history:down-or-quit }

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

use aliases

if (has-external atuin) {
	use atuin
	set edit:insert:binding[Ctrl-r] = { atuin:search }
	set edit:insert:binding[Up] = { atuin:search-up }
}
