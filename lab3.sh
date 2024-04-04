#!/bin/bash

# Transfer configure-host.sh to server1-mgmt and configure host settings
scp configure-host.sh remoteadmin@server1-mgmt:/root
ssh remoteadmin@server1-mgmt -- /root/configure-host.sh -name loghost -ip 192.168.16.3 -hostentry webhost 192.168.16.4

# Transfer configure-host.sh to server2-mgmt and configure host settings
scp configure-host.sh remoteadmin@server2-mgmt:/root
ssh remoteadmin@server2-mgmt -- /root/configure-host.sh -name webhost -ip 192.168.16.4 -hostentry loghost 192.168.16.3

# Update local /etc/hosts file
sudo ./configure-host.sh -hostentry loghost 192.168.16.3
sudo ./configure-host.sh -hostentry webhost 192.168.16.4
