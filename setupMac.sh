#!/bin/bash

echo
echo "-- macOS Dotfiles installer --"
echo


# -- Helpers --
function _create_directory {
    echo "└─> Creating directory $1"
    mkdir -p "$1"
}

function _create_symlink {
    echo "└─> Creating Symlink $2 -> $1"
    ln -sfh "$(pwd)/$1" "$2"
}

function _invoke_command {
  echo "└─> Running \"$@\""
  "$@"
}

function _install_brew_formulae {
    if brew list $1 &>/dev/null; then
        echo "└─> ${1} is already installed"
        return
    fi

    brew install $1
    echo "└─> Installed $1"
}

function _install_brew_cask {
    if brew list $1 &>/dev/null; then
        echo "└─> ${1} is already installed"
        return
    fi

    brew install --cask $1
    echo "└─> Installed $1"
}


# -- Pre Operations --
echo "Pre Operations"
_create_directory "$HOME/.config"
echo


# -- Homebrew --
echo "Checking for Homebrew"
which -s brew
if [[ $? != 0 ]]; then
    echo "└─> Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "└─> Homebrew is already installed"
fi
echo


# -- Bat --
echo "Installing bat (cat alternative)"
_install_brew_formulae "bat"
_create_symlink "Mac/Bat" "$HOME/.config/bat"
_invoke_command bat cache --build
echo


# -- Desktop --
echo "Configuring the Desktop"
_invoke_command defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool "false"
_invoke_command defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "false"
_invoke_command defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "false"
_invoke_command defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool "false"
echo


# -- Dock --
echo "Configuring the Dock"
_invoke_command defaults write com.apple.dock "autohide" -bool "true"
_invoke_command defaults write com.apple.dock "autohide-delay" -float "0"
_invoke_command defaults write com.apple.dock "autohide-time-modifier" -int "0"
_invoke_command defaults write com.apple.dock "show-recents" -bool "false"
echo


# -- Eza --
echo "Installing eza (ls alternative)"
_install_brew_formulae "eza"
echo


# -- Finder --
echo "Configuring Finder"
_invoke_command defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
_invoke_command defaults write com.apple.finder "ShowPathbar" -bool "true"
_invoke_command defaults write com.apple.Finder "FXPreferredViewStyle" "clmv"
_invoke_command defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
_invoke_command defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
_invoke_command defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
_invoke_command defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
_invoke_command defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true"
_invoke_command defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool "true"
echo


# -- Ghostty --
echo "Installing Ghostty"
_install_brew_cask "ghostty"
_create_directory "$HOME/Library/Application Support/com.mitchellh.ghostty"
_create_symlink "Mac/Ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
echo


# -- Keybinds --
echo "Configuring Keybinds"
_create_symlink "Mac/KeyBindings/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
echo


# -- Mission Control --
echo "Configuring Mission Control"
_invoke_command defaults write com.apple.dock "mru-spaces" -bool "false"
echo


# -- Starship --
echo "Installing Starship"
_install_brew_formulae "starship"
_create_symlink "Mac/Starship/starship.toml" "$HOME/.config/starship.toml"
echo


# -- Zoxide --
echo "Installing Zoxide (cd replacement)"
_install_brew_formulae "zoxide"
echo


# -- ZSH --
echo "Configuring ZSH"
_install_brew_formulae "fzf"
_create_symlink "Mac/Zsh/.zprofile" "$HOME/.zprofile"
_create_symlink "Mac/Zsh/.zshrc" "$HOME/.zshrc"
echo


# -- Post Operations --
echo "Post Operations"
_invoke_command sudo find ~ -name ".DS_Store" -depth -exec echo {} \; -exec rm {} \;
_invoke_command killall Dock
_invoke_command killall Finder
echo


# -- Summary --
echo "All Done!"
echo "Please restart your mac."
echo
