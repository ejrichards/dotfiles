function unln
	if test (count $argv) -ne 1
		echo 'Needs 1 argument'
		return 0
	end
	if not test -L $argv[1]
		echo 'File is not a symlink'
		return 1
	end
	cp --remove-destination "$(readlink $argv[1])" $argv[1]
end
