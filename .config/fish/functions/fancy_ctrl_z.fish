function fancy_ctrl_z
	if not test -n (commandline)
		fg
		commandline -f repaint
	end
end
