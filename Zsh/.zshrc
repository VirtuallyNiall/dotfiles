# -------
#   Bat
# -------
alias cat='bat'


# -------
#   Eza
# -------
alias ls="eza --oneline --icons --all --group-directories-first"


# -------
#   Git
# -------
alias gclone="git clone --recursive"


# ------------
#   Homebrew
# ------------
function blist {
  local p_output=$(brew leaves | xargs brew desc --eval-all)
  local c_output=$(brew ls --casks | xargs brew desc --eval-all)
  echo "\n-- Packages --\n$p_output"
  echo "\n-- Casks --\n$c_output"
}

function bupdate {
  brew update
  brew upgrade
  brew bundle --file ~/.config/.brewfile
  brew autoremove
  brew cleanup
}

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

# --------------
#   Kubernetes
# --------------
alias k="kubectl"


# -----------
#   Lazygit
# -----------
alias lg="lazygit"


# --------------
#   Starship
# --------------
export STARSHIP_DISTRO=""
eval "$(starship init zsh)"


# --------------
#   Utils
# --------------
function mkcd {
  mkdir $1
  z $1
}


# ----------
#   YT-DLP
# ----------
alias ytmp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"
alias ytmp3="yt-dlp --extract-audio --audio-format=mp3"
alias ytwav="yt-dlp --extract-audio --audio-format=wav"


# ----------
#   Zoxide
# ----------
alias cd="z"
eval "$(zoxide init zsh)"
