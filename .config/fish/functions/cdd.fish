if command -v wslpath &> /dev/null
	function cdd
		builtin cd $(wslpath -a "$argv")
	end
end
