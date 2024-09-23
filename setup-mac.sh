#!/bin/bash

# --------------------
#   Helper Functions
# --------------------
function symbolic_link {
    # Extract args
    local v_source="$(pwd)/$1"
    local v_target=$2

    # Create/Replace the symbolic link
    echo "- 🔗 Linking $v_source to $v_target"
    ln -sfh "$v_source" "$v_target"
}


# -----------------
#   House Keeping
# -----------------
echo '📁 Ensuring the base directories are created'
mkdir -p ~/.config


# --------
#   Dock
# --------
echo $'\n🔧 Configuring Dock delays'
defaults write com.apple.dock autohide-delay -float 0; 
defaults write com.apple.dock autohide-time-modifier -int 0;
killall Dock


# ----------
#   Finder
# ----------
echo $'\n🔧 Configuring Finder views (Deletes .DS_Store files)'
defaults write com.apple.Finder FXPreferredViewStyle clmv
sudo find / -name ".DS_Store" -depth -exec rm {} \;
killall Finder


# ------------
#   Homebrew
# ------------
which -s brew
if [[ $? != 0 ]] ; then
    echo $'\n💿 Installing Homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo $'\n🚫 Skipping Homebrew install, as it\'s already installed'
fi


# ----------------
#   Install Apps
# ----------------
echo $'\n💿 Installing Apps'
brew bundle --file ./Homebrew/Brewfile


# -------
#   Bat
# -------
echo $'\n🔧 Configuring Bat'
symbolic_link "Bat" ~/.config/bat
bat cache --build


# -------
#   Git
# -------
echo $'\n🔧 Configuring Git'
symbolic_link "Git/mac.gitconfig" ~/.gitconfig


# -------
#   K9S
# -------
echo $'\n🔧 Configuring K9S'
mkdir -p ~/Library/Application\ Support/k9s
symbolic_link "K9S/skins" ~/Library/Application\ Support/k9s/skins
symbolic_link "K9S/config.yaml" ~/Library/Application\ Support/k9s/config.yaml


# ------------
# ------------


