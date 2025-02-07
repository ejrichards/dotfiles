use builtin
use str
use os
use file

fn copy-completer {|from to|
	if (has-key $edit:completion:arg-completer $from) {
		set edit:completion:arg-completer[$to] = $edit:completion:arg-completer[$from]
	}
}

edit:add-var dot~ {|@argv| git --git-dir=$E:HOME/.dotgit/ --work-tree=$E:HOME $@argv }
copy-completer git dot

edit:add-var git-release~ {|&config='cliff.toml' @argv|
	var version = (git-cliff --bumped-version --config $config)
	var changes = (git-cliff --unreleased --bump --config $config | slurp)
	var current-tags = (git tag --contains HEAD | slurp)

	if (not-eq $current-tags '') {
		echo (styled ' WARN ' yellow) 'tags on HEAD: '$current-tags
	}

	echo $changes
	echo Tagging version $version

	if (has-external gum) {
		gum confirm 'Create tag?'
	}

	git tag -a $version -m $changes $@argv
}

if (has-external nvim) {
	edit:add-var vim~ {|@argv| nvim $@argv }
	copy-completer nvim vim
}

edit:add-var clear~ { print "\e[H\e[2J\e[3J" }
edit:add-var pwd~ { echo $pwd }
edit:add-var ssha~ { ssh -o User=ubuntu -o IdentityAgent=none -o IdentityFile=/dev/null -o IdentitiesOnly=yes -o PubkeyAuthentication=no }

set edit:command-abbr['gs'] = 'git status'
set edit:command-abbr['gsh'] = 'git show'
set edit:command-abbr['gd'] = 'git diff'
set edit:command-abbr['gds'] = 'git diff --staged'
set edit:command-abbr['gl'] = 'git log'
set edit:command-abbr['gc'] = 'git commit -m'
set edit:command-abbr['gca'] = 'git commit -am'
set edit:command-abbr['gdt'] = 'git difftool'
set edit:command-abbr['ctl'] = 'systemctl'
set edit:command-abbr['ctlu'] = 'systemctl --user'
set edit:command-abbr['sctl'] = 'sudo systemctl'
set edit:command-abbr['jctl'] = 'journalctl'
set edit:command-abbr['sjctl'] = 'sudo journalctl'

if (has-external rage) {
	edit:add-var age~ {|@argv| rage $@argv }
}
if (has-external bat) {
	edit:add-var cat~ {|@argv| bat $@argv }
	copy-completer bat cat
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

	copy-completer eza ls
	copy-completer eza ll
} else {
	fn ls {|@argv| e:ls --color=auto $@argv }
	fn ll {|@argv| ls -Al $@argv }

	edit:add-var ls~ $ls~
	edit:add-var ll~ $ll~
}

if (and (has-external rg) (not (has-external grep))) {
	edit:add-var grep~ {|@argv|
		set _ = ?(rg $@argv)
	}
	copy-completer rg grep
}
