# ----------
#   Golang
# ----------
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
mkdir -p $GOPATH/bin


# -------------
#   Homebrew
# -------------
eval "$(/opt/homebrew/bin/brew shellenv)"


# -------------
#   Jetbrains
# -------------
export PATH="$PATH:${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"


# ------------
#   Orbstack
# ------------
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
