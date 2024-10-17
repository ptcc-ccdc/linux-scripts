#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if the script is being run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Check and install sudo if not already installed
if ! command_exists "sudo"; then
    echo "Installing sudo..."
    # Use sudo to run the command if it's available, otherwise use su
    if command_exists "su"; then
        su -c "apt-get update && apt-get install -y sudo"
    else
        echo "Neither sudo nor su is available. Please install sudo manually and rerun this script."
        exit 1
    fi
fi

# Update package list and upgrade all packages
echo "Updating package list and upgrading all packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install common tools if they are not already installed
common_tools=("git")
for tool in "${common_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "$tool is not installed. Installing $tool..."
        sudo apt-get install -y "$tool"
    else
        echo "$tool is already installed."
    fi
done

# Install additional common tools
additional_tools=("curl" "wget" "vim" "net-tools")
for tool in "${additional_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "$tool is not installed. Installing $tool..."
        sudo apt-get install -y "$tool"
    else
        echo "$tool is already installed."
    fi
done

# Update package list again after installing additional tools
echo "Updating package list again..."
sudo apt-get update

# Install any missing dependencies for the installed tools
for tool in "${common_tools[@]}" "${additional_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "Installing dependencies for $tool..."
        sudo apt-get install -f
    fi
done

# Ask user for a username to add to sudoers
echo "Enter the username of the user you want to add to the sudoers file. If no user is provided, the script will complete and exit gracefully:"
read -r SUDO_USER

# If no valid username is provided, exit gracefully
if [ -z "$SUDO_USER" ]; then
    echo "No valid username provided. Completed and exiting script."
    exit 1
fi

# Add the user to sudoers if they exist and are not already in sudoers
if getent passwd "$SUDO_USER" > /dev/null 2>&1; then
    # Check if the user is already in the sudoers list
    if ! groups "$SUDO_USER" | grep -qw "sudo"; then
        echo "$SUDO_USER will be added to the sudoers file."
        # Add the user to the sudo group
        sudo usermod -aG sudo "$SUDO_USER"
        echo "User $SUDO_USER has been added to the sudo group."
    else
        echo "$SUDO_USER is already in the sudoers file."
    fi
else
    echo "User $SUDO_USER does not exist on this system."
fi
