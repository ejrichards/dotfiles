use os
use platform

if $platform:is-windows {
	set-env HOME ~
}
set-env GOPATH ~/.local/share/go
set-env BUN_INSTALL ~/.bun

if (has-external zen) {
	# Newsboat uses $E:BROWSER instead of XDG
	if (has-external uwsm) {
		set-env BROWSER 'uwsm app -- zen'
	} else {
		set-env BROWSER zen
	}
}

fn prepend-paths {|new-paths|
	set paths = [ (keep-if {|p| and (not (has-value $paths $p)) (os:is-dir $p) } $new-paths) $@paths ]
}
fn append-paths {|new-paths|
	set paths = [ $@paths (keep-if {|p| and (not (has-value $paths $p)) (os:is-dir $p) } $new-paths) ]
}

# WSL paths
if $platform:is-unix {
	prepend-paths [
		'/mnt/c/Program Files/WezTerm'
		'/mnt/c/Program Files/PowerShell/7'
	]

	if (has-env LOCALAPPDATA) {
		append-paths [
			$E:LOCALAPPDATA/Microsoft/WindowsApps/Microsoft.WindowsTerminal_8wekyb3d8bbwe
			$E:LOCALAPPDATA/wslpath
		]
	}
}

prepend-paths [
	$E:XDG_CONFIG_HOME/elvish/bin
	~/.local/bin
	$E:BUN_INSTALL/bin
	~/.cargo/bin
	/opt/gradle
	'/mnt/c/Program Files/WezTerm'
	'/mnt/c/Program Files/PowerShell/7'
]

