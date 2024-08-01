#/usr/bin/env bash
if ! grep -q '.config/bash/bashrc' ~/.bashrc; then
    cat <<EOT >> ~/.bashrc

if [ -f ~/.config/bash/bashrc ]; then
    . ~/.config/bash/bashrc
fi
EOT
fi
