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

# LD_PRELOAD fix
mv /usr/bin/thunar /usr/bin/thunar-real
mv /usr/bin/sudo /usr/bin/sudo-real

# build out conda tooling
mkdir -p /opt
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /opt
chmod -v +x /opt/Miniconda3-latest-Linux-x86_64.sh
/opt/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda
eval "$(/opt/miniconda/bin/conda shell.bash hook)"
export PATH="/opt/miniconda/bin:/opt/miniconda/condabin:/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda config --set channel_priority strict

# setup vllm environment
conda create -p /opt/conda/envs/vllm python=3.12 -y
conda activate /opt/conda/envs/vllm
pip install vllm "huggingface_hub[cli]" "open-webui[all]"
conda deactivate

# setup shared conda environments
chmod -Rv 7777 /opt/conda
chmod -Rv 7777 /opt/miniconda

# Cleanup
rm -f /opt/Miniconda3-latest-Linux-x86_64.sh
conda clean -afy
rm -rf /tmp/*
