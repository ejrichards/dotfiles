use str
use store

fn history {
	tmp E:SHELL = 'elvish'

	var key line @ignored = (str:split "\x00" (
		edit:command-history &dedup &newest-first |
		each {|cmd| printf "%s %s\x00" $cmd[id] $cmd[cmd] } |
		try {
			fzf --no-multi --no-sort --read0 --print0 --info-command="print History" ^
			--scheme=history --expect=tab,ctrl-d --border=rounded --exact ^
			--bind 'down:transform:if (<= $E:FZF_POS 1) { print abort } else { print down }' ^
			--query=$edit:current-command | slurp
		} catch {
			edit:redraw &full=$true
			return
		}
	))
	edit:redraw &full=$true

	var id command = (str:split &max=2 ' ' $line)

	if (eq $key 'ctrl-d') {
		store:del-cmd $id
		edit:notify 'Deleted '$id
	} else {
		edit:replace-input $command

		if (not-eq $key 'tab') {
			edit:return-line
		}
	}
}
