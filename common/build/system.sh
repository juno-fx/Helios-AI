#!/bin/bash

set -e

# install uv
wget -qO- https://astral.sh/uv/install.sh | sh
mv -v /root/.local/bin/uv* /usr/local/bin/

sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
mkdir -p /opt/etc/
cp -r /root/.oh-my-zsh /opt/etc/oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions /opt/etc/oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /opt/etc/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git /opt/etc/oh-my-zsh/custom/plugins/zsh-you-should-use

# install custom theme
cd /tmp/
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh -d /usr/share/themes -c dark -t orange -n Orchis -i ubuntu -s compact

# install font
mkdir -pv /usr/share/fonts/cascadia-code
cd /tmp
wget https://github.com/microsoft/cascadia-code/releases/download/v2407.24/CascadiaCode-2407.24.zip
unzip CascadiaCode-2407.24.zip
mv -v otf/static/* /usr/share/fonts/cascadia-code/
rm -rfv /tmp/*
fc-cache -f -v

# install chrome
if command -v apt &> /dev/null; then
  apt update
  apt install -y wget unzip
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb || apt -f install -y
  rm google-chrome-stable_current_amd64.deb
else
  dnf install -y wget unzip
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
  dnf install -y google-chrome-stable_current_x86_64.rpm
  rm google-chrome-stable_current_x86_64.rpm
fi

# LD_PRELOAD fix
mv /usr/bin/thunar /usr/bin/thunar-real
mv /usr/bin/sudo /usr/bin/sudo-real
mv /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable-real
mv /usr/bin/google-chrome /usr/bin/google-chrome-real

# Cleanup
rm -rf /tmp/*
