function fish_title
	if set -q SSH_CONNECTION
		echo (hostname):(prompt_pwd)
	else
		echo (prompt_pwd)
	end
end
