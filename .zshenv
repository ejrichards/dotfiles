ZDOTDIR=$HOME/.config/zsh
WD_CONFIG=$HOME/.config/zsh/.warprc
MISE_NODE_DEFAULT_PACKAGES_FILE=$HOME/.config/mise/default-npm-packages
# Might need "go env -w GOPATH=$GOPATH"
GOPATH=$HOME/.local/share/go
if [ -f $ZDOTDIR/.zshenv.local ]; then
	. $ZDOTDIR/.zshenv.local
fi
