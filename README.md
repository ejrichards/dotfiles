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

