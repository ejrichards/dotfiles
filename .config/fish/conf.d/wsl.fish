if string match -q '*microsoft*' (uname -r)
	set -gx SSH_SK_HELPER '/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe'

	function clip
		if test (count $argv) -eq 0
			pwsh.exe -Command "Get-Clipboard"
		else if test $argv = '-'
			read input
			pwsh.exe -Command "Set-Clipboard '$input'"
		else
			pwsh.exe -Command "Set-Clipboard '$argv'"
		end
	end

	function __reset_cursor --on-event fish_prompt
		echo -en '\e[2 q'
	end
end
