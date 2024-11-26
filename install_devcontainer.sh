#!/bin/bash

echo "-- Debian Devcontainer Dotfiles installer --"
echo

# --------------------
#   Helper Functions
# --------------------

# Logs and links the source to the target.
function _create_symlink {
    echo "└─> Linking $2 -> $1"
    ln -sfn "$1" "$2"
}

# Links a file or directory in the common directory.
function _create_common_symlink {
    _create_symlink "$(pwd)/common/$1" "$2"
}

# Links a file or directory in the debian directory.
function _create_debian_symlink {
    _create_symlink "$(pwd)/debian/$1" "$2"
}

# Install a package using apt
function _install_package {
    echo "└─> Installing $1 (via apt)"
    sudo apt-get update > /dev/null
    sudo apt-get -y install $1 > /dev/null
}

# Downloads a file to the specificed destination
function _download_file {
    echo "└─> Downloading $1"
    curl -sSfLo $2 $1
}

# Download and run a install script
function _download_and_invoke {
    _download_file $1 downloaded_installer.sh
    chmod +x downloaded_installer.sh
    ./downloaded_installer.sh "${@:2}"
    rm downloaded_installer.sh
}

# Download and extract a file to a directory
function _download_and_extract {
    _download_file $1 download.tar.gz
    tar xf download.tar.gz $2
    rm download.tar.gz
}

# -----------------
#   House Keeping
# -----------------
echo "Creating base directories"
mkdir -p ~/.config
mkdir -p ~/.local/bin
echo

# --------------------
#   CPU Architecture
# --------------------
echo "Detecting CPU Architecture..."
ARCH="$(dpkg --print-architecture)"
echo "└─> Detected $ARCH"
echo

# -------
#   Bat
# -------
echo "bat - Modern cat alternative"
_install_package bat
_create_common_symlink "bat" "$HOME/.config/bat"
batcat cache --build > /dev/null
echo

# -------
#   Eza
# -------
echo "eza - Modern ls alternative"
if [[ $ARCH == "arm64" ]]; then EZA_ARCH="aarch64"; else EZA_ARCH="x86_64"; fi
EZA_LINK="https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
_download_and_extract $EZA_LINK ''
mv eza ~/.local/bin/eza
echo

# -----------
#   Lazygit
# -----------
echo "lazygit - A git TUI"
if [[ $ARCH == "arm64" ]]; then LG_ARCH='arm64'; else LG_ARCH='x86_64'; fi
LG_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
LG_LINK="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VERSION}_Linux_${LG_ARCH}.tar.gz"
_download_and_extract $LG_LINK lazygit
mv lazygit ~/.local/bin/lazygit
echo

# ------------
#   Starship
# ------------
echo "starship - A nice looking prompt"
_download_and_invoke "https://starship.rs/install.sh" -y
_create_common_symlink "starship/starship.toml" "$HOME/.config/starship.toml"
echo

# ----------
#   Zoxide
# ----------
echo "zoxide - Modern cd replacement"
_download_and_invoke https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh
echo

# -------
#   Zsh
# -------
echo "zsh - default shell"
_download_and_invoke https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/install --bin
mv bin/fzf ~/.local/bin/fzf
rm -rf ./bin
_create_debian_symlink "zsh/.zshrc" "$HOME/.zshrc"
sudo usermod -s /bin/zsh vscode
echo

# ----------------
#   Post Actions
# ----------------
echo "All Done!"
echo "Please restart the shell session."
