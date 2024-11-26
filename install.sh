#!/bin/bash

# Each platform has a different set of dotfiles.
# This file runs the correct install script for your OS.
echo ""
echo " __   ___     _             _ _      _  _ _      _ _     "
echo " \ \ / (_)_ _| |_ _  _ __ _| | |_  _| \| (_)__ _| | |    "
echo "  \ V /| | '_|  _| || / _\` | | | || | .\` | / _\` | | | "
echo "   \_/ |_|_|  \__|\_,_\__,_|_|_|\_, |_|\_|_\__,_|_|_|    "
echo "                                |__/                     "
echo ""
echo "-- Dotfiles installer --"
echo

# Work out which OS the user is running.
echo "Detecting OS..."
os_name=$(uname)
if [ $? -ne 0 ]; then
    echo "└─> Error: Can't determine operating system."
    exit 1
fi

# Run the correct install script.
if [[ "$os_name" == "Darwin" ]]; then
    printf "└─> Detected macOS\n\n"
    ./install_mac.sh

elif [[ "$os_name" == "Linux" && -f /.dockerenv && -f /etc/debian_version ]]; then
    printf "└─> Detected Debian Devcontainer\n\n"
    ./install_devcontainer.sh

else
    echo "└─> Error: Unsupported operating system."
    exit 1
fi
