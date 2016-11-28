#!/bin/bash
sudo apt-get --assume-yes update 
sudo apt-get --assume-yes install nfs-kernel-server
sudo apt-get --assume-yes install nfs-common
sudo mkdir /var/nfs
sudo chown nobody:nogroup /var/nfs

sudo echo "/var/nfs    172.16.2.0/24(rw,sync,no_subtree_check,no_root_squash,nohide)" >> /etc/exports

sudo exportfs -a

sudo service nfs-kernel-server start
