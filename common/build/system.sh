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

