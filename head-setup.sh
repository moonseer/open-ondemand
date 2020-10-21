#!/bin/bash

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Add user to system and apache basic auth
groupadd ood
useradd --create-home --gid ood ood
echo -n "ood" | passwd --stdin ood

sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# Set up Host naming
hostnamectl set-hostname head
cp -f hosts /etc/hosts

# Set up Fileshare mount 
yum install cifs-utils -y
useradd -u 5000 svc_ood
groupadd -g 6000 share_ood
usermod -G share_ood -a ood
mkdir /ood_home
mount.cifs \\\\192.168.2.215\\ood\\home /ood_home -o guest,uid=1000,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm