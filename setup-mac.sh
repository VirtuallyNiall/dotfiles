#!/bin/bash

# --------------------
#   Helper Functions
# --------------------
function _create_link {
    printf "  Linking $2 to $1\n"
    ln -sfh "$1" "$2"
}

function _create_common_link {
    _create_link "$(pwd)/Common/$1" $2
}

function _create_platform_link {
    _create_link "$(pwd)/Platforms/Mac/$1" $2
}

function _install_homebrew() {
    which -s brew
    if [[ $? != 0 ]] ; then
        printf 'Installing Homebrew\n'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

function _formulae_install() {
    _install_homebrew
    if brew list $1 &>/dev/null; then
        printf "  ${1} is already installed\n"
    else
        brew install $1
        printf "  $1 is installed\n"
    fi
}

function _cask_install() {
    _install_homebrew
    if brew list $1 &>/dev/null; then
        printf "  ${1} is already installed\n"
    else
        brew install --cask $1
        printf "  $1 is installed\n"
    fi
}


# -----------------
#   House Keeping
# -----------------
printf 'Ensuring the base directories are created\n'
mkdir -p ~/.config


# -------
#   Bat
# -------
printf 'Configuring Bat\n'
_formulae_install bat
_create_common_link "Bat" ~/.config/bat
bat cache --build > /dev/null


# --------------
#   Commitizen
# --------------
printf 'Configuring Commitizen\n'
_formulae_install commitizen


# --------
#   Dock
# --------
printf 'Configuring Dock\n'
defaults write com.apple.dock autohide-delay -float 0; 
defaults write com.apple.dock autohide-time-modifier -int 0;
killall Dock


# -------
#   Eza
# -------
printf 'Configuring Eza\n'
_formulae_install eza


# ----------
#   Finder
# ----------
printf 'Configuring Finder (Deletes .DS_Store files)\n'
defaults write com.apple.Finder FXPreferredViewStyle clmv
sudo find / -name ".DS_Store" -depth -exec rm {} \;
killall Finder


# -------
#   Git
# -------
printf 'Configuring Git\n'
_create_platform_link "Git/.gitconfig" ~/.gitconfig


# ------------
#   Keybinds
# ------------
printf 'Configuring Keybinds\n'
mkdir -p ~/Library/KeyBindings
_create_platform_link "Keybinds/DefaultKeyBinding.dict" ~/Library/KeyBindings/DefaultKeyBinding.dict


# -----------
#   Lazygit
# -----------
printf 'Configuring Lazygit\n'
_formulae_install lazygit


# -------
#   SSH
# -------
printf 'Configuring SSH\n'
mkdir -p ~/.ssh
_create_platform_link "SSH/config" ~/.ssh/config


# ------------
#   Starship
# ------------
printf 'Configuring Starship\n'
_formulae_install starship
_create_common_link "Starship/starship.toml" ~/.config/starship.toml


# --------
#   Tmux
# --------
printf 'Configuring Tmux\n'
_formulae_install tmux


# ----------
#   Zoxide
# ----------
printf 'Configuring Zoxide\n'
_formulae_install zoxide


# -------
#   ZSH
# -------
printf 'Configuring Zsh\n'
_formulae_install fzf
_create_common_link Zsh/core.zshrc ~/.config/core.zshrc
_create_platform_link "ZSH/.zshrc" ~/.zshrc


# ----------------
#   Post Actions
# ----------------
printf 'All Done! Please restart the shell.\n'
