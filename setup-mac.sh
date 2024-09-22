#!/bin/bash

# --------------------
#   Helper Functions
# --------------------
function symbolic_link {
    # Extract args
    local v_target=$2
    local v_source="$(pwd)/$1"

    # Create/Replace the symbolic link
    echo "- 🔗 Linking $v_source to $v_target"
    ln -sfF $v_source $v_target
}


# -----------------
#   House Keeping
# -----------------
echo "📁 Ensuring the base directories are created"
mkdir -p ~/.config


# --------------------
#   Install Homebrew
# --------------------
which -s brew
if [[ $? != 0 ]] ; then
    echo "💿 Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "🚫 Skipping Homebrew install, as it's already installed"
fi


# ----------------
#   Install Apps
# ----------------
echo "💿 Installing Apps"
brew bundle --file ./Homebrew/Brewfile

