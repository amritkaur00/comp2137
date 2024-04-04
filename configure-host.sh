#!/bin/bash

# Default values
VERBOSE=false
NAME=""
IP=""
HOSTENTRY=""

# Function to log changes
log_changes() {
    if [ "$VERBOSE" = true ]; then
        logger -t configure-host "$1"
    fi
}

# Function to update hostname
update_hostname() {
    current_hostname=$(hostname)
    if [ "$current_hostname" != "$NAME" ]; then
        hostnamectl set-hostname "$NAME"
        log_changes "Changed hostname to $NAME"
    fi
}

# Function to update IP address
update_ip() {
    current_ip=$(hostname -I | awk '{print $1}')
    if [ "$current_ip" != "$IP" ]; then
        sudo sed -i "s/$current_ip/$IP/g" /etc/netplan/*.yaml
        sudo netplan apply
        log_changes "Changed IP address to $IP"
    fi
}

# Function to update /etc/hosts file
update_hosts_file() {
    if ! grep -q "$NAME" /etc/hosts; then
        echo "$IP $NAME" | sudo tee -a /etc/hosts > /dev/null
        log_changes "Added $NAME to /etc/hosts"
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -verbose)
            VERBOSE=true
            shift
            ;;
        -name)
            NAME="$2"
            shift
            shift
            ;;
        -ip)
            IP="$2"
            shift
            shift
            ;;
        -hostentry)
            HOSTENTRY="$2 $3"
            shift
            shift
            shift
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done

# Ignore TERM, HUP, and INT signals
trap '' TERM HUP INT

# Update hostname, IP, and /etc/hosts
if [ -n "$NAME" ]; then
    update_hostname
fi

if [ -n "$IP" ]; then
    update_ip
fi

if [ -n "$HOSTENTRY" ]; then
    update_hosts_file
fi

exit 0
