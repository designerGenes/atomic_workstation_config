#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root using sudo."
    exit
fi

# Store the username of the non-root user
USER_NAME=$(logname)

# 1. Upgrade package managers (apt, apt-get)
echo "Updating package managers..."
apt update && apt upgrade -y

# 2. Install required packages
echo "Installing required packages..."
apt install -y git gh neovim zsh tmux curl wget htop ufw python3 python3-pip python3-venv openssh-server

# Install Powerlevel10k for Zsh
echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/share/powerlevel10k

# Install Vundle for Vim
echo "Installing Vundle for Vim..."
sudo -u $USER_NAME git clone https://github.com/VundleVim/Vundle.vim.git /home/$USER_NAME/.vim/bundle/Vundle.vim

# Install zplug for Zsh
echo "Installing zplug..."
sudo -u $USER_NAME sh -c 'curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh'

# Set Zsh as the default shell for the user
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh) $USER_NAME

# 3. Enable SSH
echo "Enabling SSH..."
systemctl enable ssh
systemctl start ssh

# Connect to local Wi-Fi
echo "Connecting to Wi-Fi..."
read -p "Enter Wi-Fi SSID: " SSID
read -s -p "Enter Wi-Fi Password: " PASSWORD
echo
nmcli dev wifi connect "$SSID" password "$PASSWORD"

# 4. Accept SSH connections from systems that connect using a particular public key
echo "Configuring SSH authorized keys..."
read -p "Enter the SSH public key to allow: " PUBLIC_KEY
sudo -u $USER_NAME mkdir -p /home/$USER_NAME/.ssh
echo "$PUBLIC_KEY" >> /home/$USER_NAME/.ssh/authorized_keys
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
chmod 700 /home/$USER_NAME/.ssh
chmod 600 /home/$USER_NAME/.ssh/authorized_keys

# 5. Install Conda
echo "Installing Miniconda..."
CONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
wget https://repo.anaconda.com/miniconda/$CONDA_INSTALLER -O /tmp/$CONDA_INSTALLER
sudo -u $USER_NAME bash /tmp/$CONDA_INSTALLER -b -p /home/$USER_NAME/miniconda3

# Add Conda to PATH in .zshrc
echo "Configuring Conda in .zshrc..."
echo 'export PATH="/home/'"$USER_NAME"'/miniconda3/bin:$PATH"' >> /home/$USER_NAME/.zshrc

# 6. Add aliases to .zshrc
echo "Adding aliases to .zshrc..."
echo 'alias vimVim="vim ~/.vimrc"' >> /home/$USER_NAME/.zshrc
echo 'alias vimZ="vim ~/.zshrc"' >> /home/$USER_NAME/.zshrc
echo 'alias rezsh="source ~/.zshrc"' >> /home/$USER_NAME/.zshrc

# Change ownership of .zshrc
chown $USER_NAME:$USER_NAME /home/$USER_NAME/.zshrc

echo "Setup completed successfully. Please restart your terminal or log out and log back in for all changes to take effect."
