#!/bin/sh

# Welcome to the AIO DOCKER QUICK INSTALLER FOR DEBIAN AND UBUNTU
# Made by Sean Campbell from Chat Safe Media, and it is used for a
# Sean's Tech Talk HOW TO Video available on YouTube and CSPTube
# This combines the three things that usually take a long time to type!
# PLEASE RUN AS ROOT, YOU NEED TO DO THE REST OF YOUR DOCKER APP (EG PrestaShop) AFTER
# REBOOT.
# PLEASE RUN THIS SCRIPT ON A TEST MACHINE BEFORE USING THIS ON A PRODUCTION SERVER
# IF YOU NEED TO RUN THIS SCRIPT ON A VPS, I RECOMMEND USING OVH, AS THEY MONITOR THE SERVER

# set your domain / website as your hostname for the store and
# set the hosts file as per examples using these config settings
# SAVE THESE AS WHEN YOU REBOOT, THIS WILL BE YOUR URL IF YOU DECIDE TOUSE THESE IN NPM
# IF YOU HAVE IPv6 ADD THE FINAL LINE
# 127.0.0.1	domain.needed
# 127.0.1.1	domain.needed
# ::1		domain.needed
nano /etc/hostname && nano /etc/hosts


# updating repos for debian 11+ or ubuntu 22.04 LTS / 24.04 LTS
apt update

# UBUNTU USERS ONLY AND THIS IS OPTIONAL (ACTIVATION IS ONLY FOR VPS and DS ONLY)
# activation of Ubuntu Pro, and enabling the beta version Realtime Kernel 
# (delete the --beta command if you want the normal RTK)
# You can get Ubuntu Pro packages Activation Token  
# (More secure programs and extensions) at https://ubuntu.com/pro
# PLEASE REPLACE <ActTok> with the token shown on the dashboard
pro attach <ActTok> && clear && pro enable realtime-kernel --beta


# FROM THIS POINT ON THE FOLLOWING IS AUTOMATED AND WILL REBOOT AUTOMATICALLY
# PLEASE WAIT UP TO 5 MINUTES BEFORE ACCESSING SSH AGAIN

# installing the programs needed for docker, plus build tools
apt -y install ca-certificates gnupg build-essential curl wget apt-transport-https

# Now Upgrading EVERYTHING TO CURRENT update as per KERNEL (this is VERY important for Ubuntu Pro
# users if enabled)
apt -y upgrade

# NOW INSTALLING DOCKER
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 apt-get update -y

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y

# NOW REBOOTING, REMOVING OLD KERNEL PACKAGES AND OLD GRUB ENTRIES (FOR UBUNTU PRO IT IS NEEDED)
apt -y autoremove && reboot
