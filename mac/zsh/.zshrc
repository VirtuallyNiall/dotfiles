# -------
#   Bat
# -------
alias cat='bat'
alias catp='bat --style=plain'

# -------
#   Eza
# -------
alias ls="eza --oneline --icons --all --group-directories-first"

# -------
#   FZF
# -------
source <(fzf --zsh)

# -------
#   Git
# -------
alias gclone="git clone --recursive"

# -----------
#   History
# -----------
HISTSIZE=5000
HISTFILE=~/.zsh_history
HISTDUP=erase
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

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

# --------------
#   Starship
# --------------
export STARSHIP_DISTRO=""
eval "$(starship init zsh)"

# ---------
#   Zinit
# ---------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# ----------
#   Zoxide
# ----------
alias cd="z"
eval "$(zoxide init zsh)"

# ---------------
#   Completions
# ---------------
autoload -Uz compinit && compinit
zinit cdreplay -q
