#!/usr/bin/env elvish
if (not (has-external gum)) {
	echo Missing gum
	exit
}
if (not (has-env XDG_DATA_DIRS)) {
	echo Missing env XDG_DATA_DIRS
	exit
}

use str
use os
use path

if (== (count $args) 0) {
	var dirs = [(
		str:split : (get-env XDG_DATA_DIRS) |
		each {|data-dir| put $data-dir/icons/*[nomatch-ok] }
	)]
	echo (styled Regular green)
	put $@dirs | keep-if {|data-dir| os:is-dir $data-dir/cursors } | each {|data-dir| echo $data-dir }
	echo (styled Hyprcurosr green)
	put $@dirs | keep-if {|data-dir| os:is-regular $data-dir/manifest.hl } | each {|data-dir| echo $data-dir }
	echo (styled Local green)
	put ~/.local/share/icons/* | each {|data-dir| echo $data-dir }
	exit
} elif (!= (count $args) 1) {
	echo Usage: (path:base (src)[name]) '<theme-name>'
	exit
}
var theme-name = $args[0]

var icon-dir = (try {
	str:split : (get-env XDG_DATA_DIRS) |
	each {|data-dir| put $data-dir/icons/$theme-name } |
	keep-if {|data-dir| os:is-dir &follow-symlink=$true $data-dir } |
	take 1 |
	one
} catch { fail 'Could not find a theme: .../icons/'$theme-name })

var local-theme-dir = ~/.local/share/icons/$theme-name

if (os:exists $local-theme-dir) {
	gum confirm $local-theme-dir"\n\nDelete?"

	os:remove-all $local-theme-dir
}

cp -Lr --no-preserve=mode $icon-dir $local-theme-dir
echo Copied $icon-dir to $local-theme-dir
