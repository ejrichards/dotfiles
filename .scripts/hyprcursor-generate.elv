#!/usr/bin/env elvish
if (not (has-external hyprcursor-util)) {
	echo Missing hyprcursor-util
	exit
}
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

if (!= (count $args) 1) {
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

var local-icons = ~/.local/share/icons
var local-xcur-dir = $local-icons/$theme-name
var hypr-util-output-dir = $local-icons/theme_$theme-name'-hypr'
var local-hypr-dir = $local-icons/$theme-name'-hypr'

if (or (os:exists $local-xcur-dir) (os:exists $local-hypr-dir)) {
	gum confirm $local-xcur-dir"\n"$local-hypr-dir"\n\nDelete them?"

	os:remove-all $local-xcur-dir
	os:remove-all $local-hypr-dir
}

var tmp-dir = (os:temp-dir)

try {
	hyprcursor-util -x $icon-dir -o $tmp-dir
	sed -i 's/Extracted Theme/'$theme-name'-hypr/g' $tmp-dir/*/manifest.hl
	hyprcursor-util -c $tmp-dir/* -o $local-icons
	mv $hypr-util-output-dir $local-hypr-dir
	cp -Lr --no-preserve=mode $icon-dir $local-xcur-dir
} finally {
	os:remove-all $tmp-dir
}
