use builtin
use str

edit:add-var dot~ {|@argv| git --git-dir=$E:HOME/.dotgit/ --work-tree=$E:HOME $@argv }

edit:add-var vim~ {|@argv| nvim $@argv }
edit:add-var clear~ { edit:clear }
edit:add-var pwd~ { echo $pwd }
edit:add-var which~ {|command|
	var res = ?(search-external $command)
	if (not $res) {
		echo "Could not find '"$command"'"
	}
}

if (has-external bat) {
	edit:add-var cat~ {|@argv| bat $@argv }
}

if (has-external eza) {
	fn eza {|@argv| e:eza --group-directories-first --color=auto --time-style=relative $@argv }
	fn ls {|@argv| eza --icons=auto $@argv }
	fn ll {|@argv| eza -lahF --icons=auto --git $@argv }

	edit:add-var eza~ $eza~
	edit:add-var ls~ $ls~
	edit:add-var ll~ $ll~
	set builtin:after-chdir = [$@builtin:after-chdir {|_| ls }]
}
