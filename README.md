# dotfiles
Currently using the bare repo + git alias method for managing

### TODO: bootstrap script
Warning: Assumes no spaces in $HOME
```bash
alias dot="git --git-dir=$HOME/.dotgit --work-tree=$HOME"

cd
git clone --bare https://github.com/ejrichards/dotfiles.git .dotgit
dot config --local status.showUntrackedFiles no
dot config --local core.logAllRefUpdates true
dot config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dot config --local branch.master.remote origin
dot config --local branch.master.merge refs/heads/master
dot fetch
dot checkout
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
rm -f ~/.cache/zsh/compdump
if command -v bat &> /dev/null; then
	bat cache --build
elif command -v batcat &> /dev/null; then
	batcat cache --build
fi
EOT

cat <<EOT > ~/.dotgit/hooks/post-merge
#!/usr/bin/env bash
rm -f ~/.cache/zsh/compdump
if command -v bat &> /dev/null; then
	bat cache --build
elif command -v batcat &> /dev/null; then
	batcat cache --build
fi
EOT

chmod +x ~/.dotgit/hooks/post-checkout
chmod +x ~/.dotgit/hooks/post-merge
```
