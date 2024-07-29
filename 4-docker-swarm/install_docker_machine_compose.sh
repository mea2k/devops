#!/bin/bash
export LC_ALL=C

# install docker-engine
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable"  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin 

sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

# docker without sudo
sudo groupadd docker
sudo gpasswd -a $USER docker


docker --version
echo "Docker installed..."

#install docker compose - ставится из репозитория docker-а
sudo apt-get install -y docker-compose-plugin
# for current user
#DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
#mkdir -p $DOCKER_CONFIG/cli-plugins
#curl -SL --create-dirs "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o $DOCKER_CONFIG/cli-plugins/docker-compose
#chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# for all users
#sudo mkdir -p /usr/local/lib/docker/cli-plugins
#sudo curl -SL --create-dirs "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
#sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
#sudo chgrp -R docker /usr/local/lib/docker

docker compose version
echo "docker compose installed..."


#install docker machine
sudo curl -SL --create-dirs https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` -o /usr/local/bin/docker-machine
sudo chmod +x /usr/local/bin/docker-machine
sudo chgrp docker /usr/local/bin/docker-machine
echo "docker-machine installed..."
