#!/usr/bin/env bash
set -e
set -x

if ! command -v jq &> /dev/null; then
	echo '"jq" is missing'
	exit
fi

cd /tmp

curl https://api.github.com/repos/charmbracelet/gum/releases/latest | jq '.assets[] | select((.name | contains("Linux_x86_64")) and .content_type == "application/gzip") | .browser_download_url' | xargs --no-run-if-empty curl -L --remote-name

sudo tar xf gum*.tar.gz --directory=/usr/local/bin --no-same-owner --strip-components 1 --no-anchored "gum"
rm gum*.tar.gz
