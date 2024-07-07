#!/bin/bash

# Variables
USER="stone"
HOME_DIR="/home/$USER"
USER_BASHRC="$HOME_DIR/.bashrc"
ROOT_BASHRC="/root/.bashrc"

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install dependencies and additional software
sudo apt install -y wget unzip neovim ranger software-properties-common apt-transport-https

# Install Visual Studio Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Install Oh My Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Configure Oh My Posh for the user 'stone'
echo -e "\n# Initialize Oh My Posh\neval \"\$(oh-my-posh init bash --config ~/poshthemes/kushal.omp.json)\"" >> $USER_BASHRC

# Download the theme for 'stone'
sudo -u $USER mkdir -p $HOME_DIR/poshthemes
sudo wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/kushal.omp.json -O $HOME_DIR/poshthemes/kushal.omp.json
sudo chown -R $USER:$USER $HOME_DIR/poshthemes

# Configure Oh My Posh for the root user
echo -e "\n# Initialize Oh My Posh\neval \"\$(oh-my-posh init bash --config ~/poshthemes/hellokitty.omp.json)\"" >> $ROOT_BASHRC

# Download the theme for root
sudo mkdir -p /root/poshthemes
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/jv_sitecorian.omp.json -O /root/poshthemes/hellokitty.omp.json

# Install Fastfetch
git clone https://github.com/LinusDierheimer/fastfetch.git /tmp/fastfetch
cd /tmp/fastfetch
sudo make install
cd -
rm -rf /tmp/fastfetch

# Install btop
sudo apt install -y btop

echo "Installation complete. Please restart your terminal or source your .bashrc file."
