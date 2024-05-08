#!/usr/bin/env bash
# Start of my own super minimal `wd` for bash
# Really missed it when on servers with bash

WD_CONFIG=${WD_CONFIG:-$HOME/.warprc}
if [ ! -e "$WD_CONFIG" ]
then
    touch "$WD_CONFIG"
fi

typeset -A points
while read -r line
do
	IFS=':'; arr=($line); unset IFS;
    key=${arr[0]}
    val=${arr[1]}

    points[$key]=$val
done < "$WD_CONFIG"

function wd {
	local point=$1

	if [ $point = "list" ]
	then
		cat $WD_CONFIG
	elif [[ ${points[$point]} != "" ]]
	then
		cd ${points[$point]/#\~/$HOME}
	else
		echo "Unknown warp point '${point}'"
	fi
}
