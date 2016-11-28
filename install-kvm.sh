#!/bin/bash
sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.7.0/docker-machine-driver-kvm -o /usr/local/bin/docker-machine-driver-kvm
sudo chmod +x /usr/local/bin/docker-machine-driver-kvm

# Install libvirt and qemu-kvm on your system, e.g.
sudo apt install libvirt-bin qemu-kvm

# Add yourself to the libvirtd group (may vary by linux distro) so you don't need to sudo
sudo usermod -a -G libvirtd $(whoami)

# Update your current session for the group change to take effect
newgrp libvirtd
