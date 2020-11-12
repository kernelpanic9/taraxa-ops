#!/bin/bash

# Basic script to prepare a Ubuntu machine to run Taraxa Node using docker.
# This is initial developed to be used as startup script for cloud virtual machines to help new users to get a node running.

TARAXA_NODE_PATH=/var/taraxa
TARAXA_NODE_DOCKER_IMAGE=taraxa/taraxa:1.5.50-83

# Install docker and tools
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io git jq

# # Pull Taraxa-Node
sudo docker pull ${TARAXA_NODE_DOCKER_IMAGE}

# #Generate config
sudo docker run -d --name taraxa \
        -v ${TARAXA_NODE_PATH}:/var/taraxa \
        -e DEBUG=1 \
        -p 10002:10002 \
        -p 7777:7777 \
        -p 8777:8777 \
        -p 10002:10002/udp \
        --restart always \
        --entrypoint /usr/bin/sh \
        $TARAXA_NODE_DOCKER_IMAGE -c "taraxa config -n testnet -d /var/taraxa && ./main --conf_taraxa /var/taraxa/conf/testnet.json"