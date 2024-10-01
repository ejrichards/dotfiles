#!/usr/bin/env bash
set -e
set -x

cd /tmp

curl -L --remote-name https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz

sudo tar xf starship-x86_64-unknown-linux-gnu.tar.gz --directory=/usr/local/bin --no-same-owner
rm starship-x86_64-unknown-linux-gnu.tar.gz
