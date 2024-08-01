#/usr/bin/env bash
set -x

function dot {
	git --git-dir=$HOME/.dotgit --work-tree=$HOME "$@"
}

cd
git clone --bare https://github.com/ejrichards/dotfiles.git .dotgit
dot config --local status.showUntrackedFiles no
dot config --local core.logAllRefUpdates true
dot config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dot config --local branch.master.remote origin
dot config --local branch.master.merge refs/heads/master
dot config --local pull.ff only
dot fetch
dot checkout
