# -------
#   Bat
# -------
alias cat='bat'
alias catp='bat --style=plain'


# ------------
#   Homebrew
# ------------
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

function blist {
  local p_output=$(brew leaves | xargs brew desc --eval-all)
  local c_output=$(brew ls --casks | xargs brew desc --eval-all)
  echo "\n-- Packages --\n$p_output"
  echo "\n-- Casks --\n$c_output"
}

function bclean {
  brew update
  brew upgrade
  brew autoremove
  brew cleanup
}


# -------
#   SSH
# -------
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock


# --------------
#   Starship
# --------------
export STARSHIP_DISTRO=""


# -----------------
#   Shared Config
# -----------------
source ~/.config/core.zshrc
