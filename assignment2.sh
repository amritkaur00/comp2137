#!/bin/bash

# Configure network interface
cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
      addresses:
        - 192.168.16.21/24
      gateway4: 192.168.16.2
      nameservers:
          addresses: [192.168.16.2]
          search: [home.arpa, localdomain]
EOF
sudo netplan apply

# Updating /etc/hosts
sudo sed -i '/server1/d' /etc/hosts
sudo sed -i '1s/^/192.168.16.21 server1\n/' /etc/hosts

# Install and configure apache2 and squid
sudo apt-get update
sudo apt-get install -y apache2
sudo apt-get install -y squid

# Configuring firewall
sudo ufw allow in on ens160 to any port 22
sudo ufw allow in on any to any port 80
sudo ufw allow in on any to any port 3128
sudo ufw enable

# Creating user accounts
echo "Creating user accounts..."
    sudo useradd -m -s /bin/bash dennis
    echo "dennis ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dennis >/dev/null
    sudo mkdir -p /home/dennis/.ssh
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" | sudo tee -a /home/dennis/.ssh/authorized_keys >/dev/null
    sudo chown -R dennis:dennis /home/dennis/.ssh
    sudo chmod 700 /home/dennis/.ssh
    sudo chmod 600 /home/dennis/.ssh/authorized_keys

# Output success message
echo "Configuration completed successfully."
