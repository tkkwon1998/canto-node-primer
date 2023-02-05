#!/usr/bin/env bash

set -e

# Updates system and installs dependencies
sudo apt update
sudo apt install make && sudo apt install gcc
wget https://golang.org/dl/go1.18.3.linux-amd64.tar.gz
sudo tar -xvf go1.18.3.linux-amd64.tar.gz -C /usr/local
sudo chown -R plex:plex /usr/local/go
echo "export GOPATH=$HOME/go \nexport PATH=$PATH:$GOPATH/bin:/usr/local/go/bin"  | tee -a ~/.profile

cd ..
git clone https://github.com/Canto-Network/Canto.git
cd Canto
git checkout v5.0.0

# Installs and builds Canto daemon program
make install

rm -rf ~/.cantod/config/genesis.json
wget https://raw.githubusercontent.com/Canto-Network/Canto/genesis/Networks/Mainnet/genesis.json -P $HOME/.cantod/config/

# Syncs node
cd $HOME/canto-node-primer
chmod 700 state_sync.sh
./state_sync.sh
cantod start
