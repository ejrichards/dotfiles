use builtin
use str
use os
use file

edit:add-var dot~ {|@argv| git --git-dir=$E:HOME/.dotgit/ --work-tree=$E:HOME $@argv }
set edit:completion:arg-completer[dot] = $edit:completion:arg-completer[git]

edit:add-var vim~ {|@argv| nvim $@argv }
set edit:completion:arg-completer[vim] = $edit:completion:arg-completer[nvim]

edit:add-var clear~ { print "\e[H\e[2J\e[3J" }
edit:add-var pwd~ { echo $pwd }
edit:add-var ssha~ { ssh -o User=ubuntu -o IdentityAgent=none -o IdentityFile=/dev/null -o IdentitiesOnly=yes -o PubkeyAuthentication=no }

edit:add-var which~ {|command|
	var res = ?(search-external $command)
	if (not $res) {
		echo "Could not find '"$command"'"
	}
}

set edit:command-abbr['gs'] = 'git status'
set edit:command-abbr['gsh'] = 'git show'
set edit:command-abbr['gd'] = 'git diff'
set edit:command-abbr['gl'] = 'git log'
set edit:command-abbr['gc'] = 'git commit -m'
set edit:command-abbr['gca'] = 'git commit -am'
set edit:command-abbr['gdt'] = 'git difftool'
set edit:command-abbr['ctl'] = 'systemctl'
set edit:command-abbr['sctl'] = 'sudo systemctl'
set edit:command-abbr['jctl'] = 'journalctl'
set edit:command-abbr['sjctl'] = 'sudo journalctl'

if (has-external rage) {
	edit:add-var age~ {|@argv| rage $@argv }
}
if (has-external bat) {
	edit:add-var cat~ {|@argv| bat $@argv }
	set edit:completion:arg-completer[cat] = $edit:completion:arg-completer[bat]
}
if (has-external yazi) {
	use github.com/ejrichards/mellon/yazi
	edit:add-var y~ $yazi:y~
}

if (has-external eza) {
	fn eza {|@argv| e:eza --group-directories-first --color=auto --time-style=relative $@argv }
	fn ls {|@argv| eza --icons=auto $@argv }
	fn ll {|@argv| eza -lahF --icons=auto --git $@argv }

	edit:add-var eza~ $eza~
	edit:add-var ls~ $ls~
	edit:add-var ll~ $ll~
	# set builtin:after-chdir = [$@builtin:after-chdir {|_| edit:notify (eza --icons=always -w 120 | slurp) }]

	set edit:completion:arg-completer[ls] = $edit:completion:arg-completer[eza]
	set edit:completion:arg-completer[ll] = $edit:completion:arg-completer[eza]
}

if (and (has-external rg) (not (has-external grep))) {
	edit:add-var grep~ {|@argv|
		set _ = ?(rg $@argv)
	}
	set edit:completion:arg-completer[grep] = $edit:completion:arg-completer[rg]
}
