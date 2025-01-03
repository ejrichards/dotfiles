use str
use platform

if $platform:is-unix {
	if (str:contains (uname -r) microsoft) {
		set-env SSH_SK_HELPER '/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe'
	}
}
