#!/bin/sh
set -e

sudo apt update
sudo apt upgrade -y

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create github user
sudo mkdir -p /home/app
sudo useradd --no-create-home --home-dir /home/app --shell /bin/bash github
sudo usermod --append --groups docker github
sudo usermod --append --groups docker ubuntu
sudo chown github:github -R /home/app

github_pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC59/A7DYjxv19+yWCBjAiknGmlCbTJUsyJnHZsGk8TNu/lkTB20Gxs7DaBi0d/9UR5zITr3iGlj79SlsYpmkP82yTc5H9aIDbZiqsmSqAMqU/pbfLUc95+tUED6/wduF0fgrXv4YgTSsqRxOm/vyEJBPj7u3LPCxNup+ZPKWx8tPtEtFNIszilpRj8cVmo07jyukGEkEJVmbr22hxMhjwYWcX08TsyXfFsqKkaEuNITL49SmO8xqD6h+em2oqUAPKXOaktzRv5PODpECp2wDgwR7GKt/80b6HDhtxw05UxPlkftmwNaFNpxSHF1Wnf8CFKaC8ZuO9Imt4PoOzncyeDf1TWMwb4plNl3Jnc+eJHeyv3WX1B1HxkOs6X2BYcZ3eZXNdNE88Iw31uwI+Cm2aj5F5yyDvu4M/oKyCO3M8Zp8CsJ4s2BETAj3fsQxIiayjlD4jLm4DgwqO5y31GxjN9FP75YiouUdBq2/JuDQQBoN0BW1MX9L6QdKzAC9BwZY2nXq8sbBp7fLTYRHm6VrH9NcIOpWbEOUyqoj7Zx2+1YosPYrCEAMu/Av+m2wkt1L5Jxdy+fu2BAydV5OfzexVxfBeMVySrLCu+wmG9NoJ1FmutbvwWQGvZ1T7B3Qr/o8vPXOmQplI3nJ6d+ui65M7buPAvGb84aqlKPs1uTnRbcw== 151037@ppu.edu.ps'

sudo -u github sh -c "mkdir -p /home/app/.ssh && echo $github_pubkey > /home/app/.ssh/authorized_keys"

sudo reboot