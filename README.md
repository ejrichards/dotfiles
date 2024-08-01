# dotfiles
Currently using the bare repo + git alias method for managing

Warning: Assumes no spaces in $HOME
```bash
curl https://raw.githubusercontent.com/ejrichards/dotfiles/master/.scripts/bootstrap.sh | bash
```

Add write
```bash
dot remote set-url --push origin git@github.com:ejrichards/dotfiles.git
dot config --local user.signingkey $HOME/.ssh/id_ed25519_sk.pub
dot config --local gpg.format ssh
dot config --local commit.gpgsign true
```

Hooks to clean/build caches
```bash
cat <<EOT > ~/.dotgit/hooks/post-checkout
#!/usr/bin/env bash
if command -v bat &> /dev/null; then
	bat cache --build
elif command -v batcat &> /dev/null; then
	batcat cache --build
fi
EOT

cat <<EOT > ~/.dotgit/hooks/post-merge
#!/usr/bin/env bash
if command -v bat &> /dev/null; then
	bat cache --build
elif command -v batcat &> /dev/null; then
	batcat cache --build
fi
EOT

chmod +x ~/.dotgit/hooks/post-checkout
chmod +x ~/.dotgit/hooks/post-merge
```

Update .bashrc
```bash
if ! grep -q '.config/bash/bashrc' ~/.bashrc; then
    cat <<EOT >> ~/.bashrc

if [ -f ~/.config/bash/bashrc ]; then
    . ~/.config/bash/bashrc
fi
EOT
fi
```

Download starship
```bash
curl -L --remote-name https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz && sudo tar xf starship-x86_64-unknown-linux-gnu.tar.gz --directory=/usr/local/bin --no-same-owner && rm starship-x86_64-unknown-linux-gnu.tar.gz
```

Download gum
```bash
curl https://api.github.com/repos/charmbracelet/gum/releases/latest | jq '.assets[] | select((.name | contains("Linux_x86_64")) and .content_type == "application/gzip") | .browser_download_url' | xargs --no-run-if-empty curl -L --remote-name && sudo tar xf gum*.tar.gz --directory=/usr/local/bin --no-same-owner --strip-components 1 --no-anchored "gum" && rm gum*.tar.gz
```
