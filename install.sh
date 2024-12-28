#!/bin/bash

echo ""
echo " __   ___     _             _ _      _  _ _      _ _     "
echo " \ \ / (_)_ _| |_ _  _ __ _| | |_  _| \| (_)__ _| | |    "
echo "  \ V /| | '_|  _| || / _\` | | | || | .\` | / _\` | | | "
echo "   \_/ |_|_|  \__|\_,_\__,_|_|_|\_, |_|\_|_\__,_|_|_|    "
echo "                                |__/                     "
echo ""
echo "-- macOS Dotfiles installer --"
echo

# --------------------
#   Helper Functions
# --------------------

# Logs and links the source to the target.
function _create_symlink {
    echo "└─> Linking $2 -> $1"
    ln -sfh "$1" "$2"
}

# Links a file or directory in the common directory.
function _create_common_symlink {
    _create_symlink "$(pwd)/common/$1" "$2"
}

# Links a file or directory in the mac directory.
function _create_mac_symlink {
    _create_symlink "$(pwd)/mac/$1" "$2"
}

# Asks the user a question.
function _prompt {
    while true; do
        read -p "Do you want to $1? [Y/n]: " answer
        case "$answer" in
        "N" | "n")
            return 1 # False
            ;;
        "Y" | "y" | "")
            return 0 # True
            ;;
        *)
            echo "└─> Invalid input! Please enter Y or N."
            ;;
        esac
    done
}

# Installs homebrew if it's not already installed.
function _install_homebrew {
    which -s brew
    if [[ $? != 0 ]]; then
        echo "└─> Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# Installs a homebrew formulae
function _formulae_install {
    # Ignore if we don't want to install the package
    if ! _prompt "install $1 (via Homebrew)"; then
        return
    fi

    # Ensure homebrew is installed
    _install_homebrew

    # Make sure the package isn't installed
    if brew list $1 &>/dev/null; then
        echo "└─> ${1} is already installed"
        return
    fi

    # Install the package
    brew install $1
    echo "└─> Installed $1"
}

# Installs a homebrew cask
function _cask_install() {
    # Ignore if we don't want to install the cask
    if ! _prompt "install $1 (via Homebrew)"; then
        return
    fi

    # Ensure homebrew is installed
    _install_homebrew

    # Make sure the package isn't installed
    if brew list $1 &>/dev/null; then
        echo "└─> ${1} is already installed"
        return
    fi

    # Install the package
    brew install --cask $1
    echo "└─> Installed $1"
}

# -----------------
#   House Keeping
# -----------------
echo "Creating base directories"
mkdir -p ~/.config
echo

# -------
#   Bat
# -------
echo "bat - Modern cat alternative"
_formulae_install bat
if _prompt "link the bat dotfiles"; then
    _create_common_symlink "bat" "$HOME/.config/bat"
    bat cache --build >/dev/null
fi
echo

# --------
#   Dock
# --------
echo "dock - General modifications"
if _prompt "reduce the dock hide/show delay"; then
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -int 0
    killall Dock
fi
echo

# -------
#   Eza
# -------
echo "eza - Modern ls alternative"
_formulae_install eza
echo

# ----------
#   Finder
# ----------
echo "dock - General modifications"
if _prompt "default to the column view"; then
    defaults write com.apple.Finder FXPreferredViewStyle clmv
fi
if _prompt "remove the existing .DS_Store files (Requires sudo)"; then
    sudo find ~ -name ".DS_Store" -depth -exec rm {} \;
    killall Finder
fi
echo

# -------
#   Git
# -------
echo "git - Version control"
if _prompt "link the git dotfiles"; then
    _create_mac_symlink "git/.gitconfig" "$HOME/.gitconfig"
fi
echo

# ------------
#   Keybinds
# ------------
echo "keybinds - General fixes"
if _prompt "add home/end fixes"; then
    _create_mac_symlink "keybinds/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
    echo "└─> Please restart your mac to activate the fixes!"
fi
echo

# -----------
#   Lazygit
# -----------
echo "lazygit - A git TUI"
_formulae_install lazygit
if _prompt "link the lazygit dotfiles"; then
    mkdir -p "$HOME/Library/Application Support/lazygit"
    _create_common_symlink "lazygit/config.yaml" "$HOME/Library/Application Support/lazygit/config.yml"
fi
echo

# ------------
#   Starship
# ------------
echo "starship - A nice looking prompt"
_formulae_install starship
if _prompt "link the starship dotfiles"; then
    _create_common_symlink "starship/starship.toml" "$HOME/.config/starship.toml"
fi
echo

# ----------
#   Zoxide
# ----------
echo "zoxide - Modern cd replacement"
_formulae_install zoxide
echo

# -------
#   ZSH
# -------
echo "zsh - default shell"
_formulae_install fzf
if _prompt "link the zsh dotfiles"; then
    _create_mac_symlink "zsh/.zshrc" "$HOME/.zshrc"
fi
echo

# -----------
#   Summary
# -----------
echo "All Done!"
echo "You may need to restart the shell session."
echo "You should anyway though :)"
