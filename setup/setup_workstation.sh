#!/bin/bash

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget vim htop zsh ufw python3-pip build-essential git

echo "Setting default shell to zsh..."
chsh -s $(which zsh)
rm "$HOME/.zshrc"
cp ./cfg/.zshrc $HOME
# Install zplug for managing zsh plugins
echo "Installing zplug..."
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

echo "Installing Oh My Zsh..."
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

source "$HOME/.zshrc"

echo "configuring vim theme"
cp ./cfg/.vimrc $HOME
vim -c 'source ~/.vimrc' -c ':PluginInstall' -c 'q'
echo "Setup complete. Please restart your terminal or log out and back in for changes to take effect."
