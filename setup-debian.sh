#!/bin/bash

# ---------
#   Setup
# ---------
# Exit if a command fails
set -e 

# Get CPU arch
ARCH="$(dpkg --print-architecture)"


# --------------------
#   Helper Functions
# --------------------
function _create_link {
    printf "  Linking $2 to $1\n"
    ln -sfn "$1" "$2"
}

function _create_common_link {
    _create_link "$(pwd)/Common/$1" $2
}

function _create_platform_link {
    _create_link "$(pwd)/Platforms/Debian/$1" $2
}

function _install_package {
    printf "  Installing $1\n"
    sudo apt-get update > /dev/null
    sudo apt-get -y install $1 > /dev/null
}

function _download_and_extract {
    curl -Lo download.tar.gz $1
    tar xf download.tar.gz $2
    rm download.tar.gz
}


# -----------------
#   House Keeping
# -----------------
printf 'Ensuring the base directories are created\n'
mkdir -p ~/.config
mkdir -p ~/.local/bin


# -------
#   Bat
# -------
printf 'Configuring Bat\n'
_install_package bat
_create_common_link Bat ~/.config/bat
batcat cache --build > /dev/null


# --------------
#   Commitizen
# --------------
printf 'Configuring Commitizen\n'
_install_package pipx
pipx install commitizen


# -------
#   Eza
# -------
printf 'Configuring Eza\n'
if [[ $ARCH == "arm64" ]]; then EZA_ARCH='aarch64'; else EZA_ARCH='x86_64'; fi
EZA_LINK="https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
_download_and_extract $EZA_LINK ''
mv eza ~/.local/bin/eza


# -------
#   Git
# -------
printf 'Configuring Git\n'
_install_package git
_create_platform_link "Git/.gitconfig" ~/.gitconfig


# -----------
#   Lazygit
# -----------
printf 'Configuring Lazygit\n'
if [[ $ARCH == "arm64" ]]; then LG_ARCH='arm64'; else LG_ARCH='x86_64'; fi
LG_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
LG_LINK="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VERSION}_Linux_${LG_ARCH}.tar.gz"
_download_and_extract $LG_LINK lazygit
mv lazygit ~/.local/bin/lazygit


# ------------
#   Starship
# ------------
printf 'Configuring Starship\n'
curl -sS https://starship.rs/install.sh | sh
_create_common_link Starship/starship.toml ~/.config/starship.toml


# --------
#   Tmux
# --------
printf 'Configuring Tmux\n'
_install_package tmux


# ----------
#   Zoxide
# ----------
printf 'Configuring Zoxide\n'
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


# -------
#   Zsh
# -------
printf 'Configuring Zsh\n'
_install_package fzf
_create_common_link Zsh/core.zshrc ~/.config/core.zshrc
_create_platform_link Zsh/.zshrc ~/.zshrc


# ----------------
#   Post Actions
# ----------------
printf 'All Done! Please restart the shell!\n'
