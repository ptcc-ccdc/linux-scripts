#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check and install Firewalld if not installed
if ! command_exists firewall-cmd; then
    echo "Firewall is not installed. Installing now..."
    if command_exists apt; then
        apt update && apt install -y firewalld
    elif command_exists yum; then
        yum install -y firewalld
    else
        echo "Package manager not found"
        exit 1
    fi
fi

# Check Firewalld path and clear rules
if [ -d /etc/firewalld/zones ]; then
    rm -rf /etc/firewalld/zones/*
    echo "Firewalld path is /etc/firewalld"
elif [ -d /usr/etc/firewalld/zones ]; then
    rm -rf /usr/etc/firewalld/zones/*
    echo "Firewalld path is /usr/etc/firewalld"
else
    echo "Firewalld not found"
    exit 1
fi

# Function to add ports based on service type
add_ports() {
    case $opt in
        "ecomm")
            echo "You chose ecomm"
            firewall-cmd --add-port=80/tcp
            firewall-cmd --add-port=3306/tcp
            # Consider adding appropriate ports for an e-commerce service
            ;;
        "web")
            echo "You chose web"
            firewall-cmd --add-port=80/tcp
            firewall-cmd --add-port=3306/tcp
            # Consider adding appropriate ports for a web service
            ;;
        "splunk")
            echo "You chose splunk"
            firewall-cmd --add-port=8089/tcp
            firewall-cmd --add-port=8865/tcp
            firewall-cmd --add-port=8000/tcp
            firewall-cmd --add-port=8191/tcp
            ;;
        "dns")
            echo "You chose dns"
            firewall-cmd --add-port=53/tcp
            firewall-cmd --add-port=25/tcp
            firewall-cmd --add-port=111/tcp
            firewall-cmd --add-port=21/tcp
            firewall-cmd --add-port=953/tcp
            firewall-cmd --add-port=80/tcp
            ;;
        "mail")
            echo "You chose mail"
            firewall-cmd --add-port=2049/tcp
            firewall-cmd --add-port=110/tcp
            firewall-cmd --add-port=111/tcp
            firewall-cmd --add-port=143/tcp
            firewall-cmd --add-port=25/tcp
            firewall-cmd --add-port=3306/tcp
            firewall-cmd --add-port=80/tcp
            ;;
        "workstation")
            echo "You chose workstation"
            ;;
        "clear")
            echo "You have cleared all firewall rules"
            ;;
        *)
            echo "Invalid option selected"
            ;;
    esac
}

# Main script logic
while true; do
    read -rp "Choose an option (ecomm, web, splunk, dns, mail, workstation, clear): " opt
    case $opt in
        "ecomm"|"web"|"splunk"|"dns"|"mail"|"workstation"|"clear")
            add_ports
            break
            ;;
        *)
            echo "Invalid option selected. Please choose a valid option."
            ;;
    esac
done
