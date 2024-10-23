This is a repo including Linux Scripts for CCDC

<details>
<summary><h5>firewall-setup.sh</h5></summary>

# Firewalld Configuration Script

This document provides a detailed explanation of a Bash script designed to configure the `Firewalld` firewall on a Linux system. The script is particularly useful for system administrators and cybersecurity professionals who need to manage firewall rules for different types of services. The script can install `Firewalld` if it is not already installed, clear existing firewall rules, and add specific ports based on the type of service being configured.

## Introduction

The script performs the following tasks:
1. Checks if `Firewalld` is installed and installs it if necessary.
2. Clears existing firewall rules.
3. Adds specific ports based on the type of service selected by the user.
4. Provides a user-friendly interface for selecting the service type.

## Prerequisites

- A Linux system with access to either the `apt` or `yum` package manager.
- Basic knowledge of Bash scripting and Linux command-line operations.

## Script Overview

The script is structured to ensure that `Firewalld` is installed, existing rules are cleared, and specific ports are added based on the user's selection. It is designed to be robust and handle various scenarios, such as the absence of `Firewalld` or the specified service type not being valid.

## Detailed Explanation

### Function to Check Command Existence

```bash
command_exists() {
    command -v "$1" &>/dev/null
}
```

- **Purpose**: This function checks if a given command is available on the system.
- **Usage**: `command_exists "firewall-cmd"` will return true if `firewall-cmd` is installed, otherwise false.

### Check and Install Firewalld

```bash
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
```

- **Purpose**: This block checks if `Firewalld` is installed and installs it if necessary.
- **Explanation**: If `firewall-cmd` is not available, the script checks if `apt` or `yum` is available and uses the appropriate package manager to install `Firewalld`. If neither package manager is available, the script exits with an error message.

### Clear Firewall Rules

```bash
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
```

- **Purpose**: This block clears existing firewall rules by removing all configuration files in the `zones` directory.
- **Explanation**: It checks if the `Firewalld` configuration directory is located at `/etc/firewalld/zones` or `/usr/etc/firewalld/zones`. If found, it removes all files in the directory. If neither directory is found, the script exits with an error message.

### Function to Add Ports Based on Service Type

```bash
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
```

- **Purpose**: This function adds specific ports to the firewall based on the type of service selected by the user.
- **Explanation**: It uses a `case` statement to handle different service types:
  - **ecomm**: Adds ports 80/tcp and 3306/tcp.
  - **web**: Adds ports 80/tcp and 3306/tcp.
  - **splunk**: Adds ports 8089/tcp, 8865/tcp, 8000/tcp, and 8191/tcp.
  - **dns**: Adds ports 53/tcp, 25/tcp, 111/tcp, 21/tcp, 953/tcp, and 80/tcp.
  - **mail**: Adds ports 2049/tcp, 110/tcp, 111/tcp, 143/tcp, 25/tcp, 3306/tcp, and 80/tcp.
  - **workstation**: No specific ports are added.
  - **clear**: Clears all firewall rules.
  - **Default**: Handles invalid options by printing an error message.

### Main Script Logic

```bash
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
```

- **Purpose**: This block provides a user-friendly interface for selecting the service type.
- **Explanation**: It prompts the user to choose an option from a list of valid service types. If a valid option is selected, it calls the `add_ports` function and breaks out of the loop. If an invalid option is selected, it prints an error message and prompts the user again.

## Example Usage

1. **Save the Script**: Save the script to a file, for example, `configure_firewalld.sh`.
2. **Make the Script Executable**:
   ```bash
   chmod +x configure_firewalld.sh
   ```
3. **Run the Script**:
   ```bash
   ./configure_firewalld.sh
   ```
4. **Follow the Prompts**: The script will prompt you to choose an option from the list of valid service types. Enter the desired option and press Enter.

## Conclusion

This script is a comprehensive tool for configuring the `Firewalld` firewall on a Linux system. It ensures that the firewall is installed, existing rules are cleared, and specific ports are added based on the type of service being configured. By following the steps outlined in this document, you can effectively use the script to manage your firewall rules and enhance the security of your system.
</details>
<details>
<summary><h5>debian-basic-setup.sh</h5></summary>

# Network Setup and User Management Script for Debian Based Systems

This document provides a detailed explanation of a Bash script designed to set up a system with common tools and user management. The script is particularly useful for system administrators and cybersecurity professionals who need to ensure that a system is properly configured with the necessary tools and that users have the appropriate permissions.

## Introduction

The script performs the following tasks:
1. Ensures the script is not run as the root user.
2. Installs `sudo` if it is not already available.
3. Updates and upgrades all system packages.
4. Installs a list of common tools.
5. Installs additional common tools.
6. Ensures all dependencies for the installed tools are met.
7. Adds a specified user to the sudoers file if they are not already in it.

## Prerequisites

- A Linux system with access to the `apt` package manager.
- Basic knowledge of Bash scripting and Linux command-line operations.

## Script Overview

The script is structured to ensure that it can be run by a regular user and that it will configure the system with the necessary tools and user permissions. It is designed to be robust and handle various scenarios, such as the absence of `sudo` or the specified user not existing.

## Detailed Explanation

### Function to Check Command Existence

```bash
command_exists() {
    command -v "$1" &> /dev/null
}
```

- **Purpose**: This function checks if a given command is available on the system.
- **Usage**: `command_exists "git"` will return true if `git` is installed, otherwise false.

### Check for Root User

```bash
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi
```

- **Purpose**: This block ensures that the script is not run as the root user.
- **Explanation**: If the script is run as root, it prints a warning message and exits with an error code.

### Install Sudo if Not Available

```bash
if ! command_exists "sudo"; then
    echo "Installing sudo..."
    if command_exists "su"; then
        su -c "apt-get update && apt-get install -y sudo"
    else
        echo "Neither sudo nor su is available. Please install sudo manually and rerun this script."
        exit 1
    fi
fi
```

- **Purpose**: This block installs `sudo` if it is not already installed.
- **Explanation**: If `sudo` is not available, the script checks if `su` is available and uses it to install `sudo`. If neither `sudo` nor `su` is available, the script exits with an error message.

### Update and Upgrade Packages

```bash
echo "Updating package list and upgrading all packages..."
sudo apt-get update && sudo apt-get upgrade -y
```

- **Purpose**: This block updates the package list and upgrades all installed packages.
- **Explanation**: It uses `sudo` to run the `apt-get update` and `apt-get upgrade` commands, ensuring that the system has the latest package versions.

### Install Common Tools

```bash
common_tools=("git")
for tool in "${common_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "$tool is not installed. Installing $tool..."
        sudo apt-get install -y "$tool"
    else
        echo "$tool is already installed."
    fi
done
```

- **Purpose**: This block installs a list of common tools if they are not already installed.
- **Explanation**: It iterates over the `common_tools` array and checks if each tool is installed. If a tool is not installed, it uses `sudo` to install it.

### Install Additional Common Tools

```bash
additional_tools=("curl" "wget" "vim" "net-tools")
for tool in "${additional_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "$tool is not installed. Installing $tool..."
        sudo apt-get install -y "$tool"
    else
        echo "$tool is already installed."
    fi
done
```

- **Purpose**: This block installs additional common tools if they are not already installed.
- **Explanation**: Similar to the previous block, it iterates over the `additional_tools` array and installs any missing tools.

### Update Package List Again

```bash
echo "Updating package list again..."
sudo apt-get update
```

- **Purpose**: This block updates the package list again after installing additional tools.
- **Explanation**: It ensures that the package list is up-to-date after any new installations.

### Install Missing Dependencies

```bash
for tool in "${common_tools[@]}" "${additional_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "Installing dependencies for $tool..."
        sudo apt-get install -f
    fi
done
```

- **Purpose**: This block installs any missing dependencies for the installed tools.
- **Explanation**: It checks if any of the tools are still missing and installs their dependencies using `sudo apt-get install -f`.

### Add User to Sudoers

```bash
echo "Enter the username of the user you want to add to the sudoers file. If no user is provided, the script will complete and exit gracefully:"
read -r SUDO_USER

if [ -z "$SUDO_USER" ]; then
    echo "No valid username provided. Completed and exiting script."
    exit 1
fi

if getent passwd "$SUDO_USER" > /dev/null 2>&1; then
    if ! groups "$SUDO_USER" | grep -qw "sudo"; then
        echo "$SUDO_USER will be added to the sudoers file."
        sudo usermod -aG sudo "$SUDO_USER"
        echo "User $SUDO_USER has been added to the sudo group."
    else
        echo "$SUDO_USER is already in the sudoers file."
    fi
else
    echo "User $SUDO_USER does not exist on this system."
fi
```

- **Purpose**: This block adds a specified user to the sudoers file if they are not already in it.
- **Explanation**: It prompts the user to enter a username and checks if the user exists. If the user exists and is not already in the sudoers file, it adds the user to the sudo group.

## Example Usage

1. **Save the Script**: Save the script to a file, for example, `setup.sh`.
2. **Make the Script Executable**:
   ```bash
   chmod +x setup.sh
   ```
3. **Run the Script**:
   ```bash
   ./setup.sh
   ```
4. **Follow the Prompts**: The script will prompt you to enter a username to add to the sudoers file. Enter a valid username or press Enter to exit the script.

## Conclusion

This script is a comprehensive tool for setting up a Linux system with common tools and managing user permissions. It ensures that the system is up-to-date and that the specified user has the necessary privileges to perform administrative tasks. By following the steps outlined in this document, you can effectively use the script to streamline your system setup and user management processes.
</details>
<details>
<summary><h5>ubuntuv2.py</h5></summary>

# Network and System Management Script

This document provides a detailed explanation of a Python script designed to manage various network and system configurations. The script is particularly useful for system administrators and cybersecurity professionals who need to perform tasks such as listing active connections, managing cron jobs, stopping services, and setting up a TFTP server. The script provides a user-friendly interface for selecting and executing these tasks.

## Introduction

The script performs the following tasks:
1. Lists all active network connections.
2. Clears all cron jobs for all users.
3. Stops an Upstart service.
4. Stops a SysV service.
5. Lists and kills TCP connections.
6. Kills active pts/tty sessions.
7. Resets the firewall to default settings.
8. Sets up a TFTP server.

## Prerequisites

- A Linux system with Python installed.
- Sudo privileges for certain commands.
- Basic knowledge of Python and Linux command-line operations.

## Script Overview

The script is structured to provide a menu-based interface for the user to select and execute the desired task. Each task is handled by a specific block of code, ensuring that the script is modular and easy to maintain.

## Detailed Explanation

### List All Active Connections

```python
if choice == "1":
    os.system("ss")
```

- **Purpose**: This block lists all active network connections.
- **Explanation**: It uses the `ss` command to display active connections.

### Clear All Cron Jobs

```python
elif choice == "2":
    cron = raw_input("Do you want to remove all cron jobs? Y/N: ")
    if cron.lower() == "y":
        try:
            os.chdir("/var/spool/cron")
            for user in os.listdir("."):
                with open(user, "w") as f:
                    f.write("")
                print("Cleared cron jobs for user: " + user)
            print("All cron jobs cleared")
        except OSError as e:
            print("Error clearing cron jobs:", e)
```

- **Purpose**: This block clears all cron jobs for all users.
- **Explanation**: It prompts the user to confirm the action. If confirmed, it changes to the `/var/spool/cron` directory and clears the cron files for each user.

### Stop an Upstart Service

```python
elif choice == "3":
    while True:
        print("Current Upstart services:")
        os.system("service --status-all")
        upchoice = raw_input("Enter the name of a service to stop (or 'n' to exit): ")
        if upchoice.lower() == "n":
            break
        upcommand = "sudo service " + upchoice + " stop"
        try:
            status = os.system(upcommand)
            if status == 0:
                print("Service stopped successfully")
            else:
                print("Error stopping service")
        except OSError as e:
            print("Error stopping service:", e)
```

- **Purpose**: This block stops an Upstart service.
- **Explanation**: It lists all Upstart services and prompts the user to enter the name of the service to stop. It continues to prompt until the user chooses to exit.

### Stop a SysV Service

```python
elif choice == "4":
    while True:
        print("Current SysV services:")
        os.system("sudo initctl list")
        upchoice = raw_input("Enter the name of a service to stop (or 'n' to exit): ")
        if upchoice.lower() == "n":
            break
        upcommand = "sudo killall " + upchoice
        try:
            status = os.system(upcommand)
            if status == 0:
                print("Service stopped successfully")
            else:
                print("Error stopping service")
        except OSError as e:
            print("Error stopping service:", e)
```

- **Purpose**: This block stops a SysV service.
- **Explanation**: It lists all SysV services and prompts the user to enter the name of the service to stop. It continues to prompt until the user chooses to exit.

### List and Kill TCP Connections

```python
elif choice == "5":
    print("Listing TCP connections")
    os.system("ss | grep tcp")
    tcpkill = raw_input("If you want to kill all connections from IP enter Y/N: ")
    if tcpkill.lower() == "y":
        ip = raw_input("Enter the IP address: ")
        os.system("sudo tcpkill host {}".format(ip))
        os.system("tcpkill -i eth0 port 22")
        print("killing all ssh connections if any")
```

- **Purpose**: This block lists all TCP connections and allows the user to kill connections from a specific IP address.
- **Explanation**: It lists all TCP connections and prompts the user to enter the IP address of the connections to kill. It then uses `tcpkill` to terminate the connections.

### Kill Active pts/tty

```python
elif choice == "6":
    print("Listing active pts/tty")
    os.system("ps aux | grep sh")
    ptskill = raw_input("If you want to kill a pts/tty enter Y/N: ")
    if ptskill.lower() == "y":
        ptsnum = raw_input("Enter the pts/tty number: ")
        os.system("sudo kill -9 {}".format(ptsnum))
```

- **Purpose**: This block lists active pts/tty sessions and allows the user to kill a specific session.
- **Explanation**: It lists all active pts/tty sessions and prompts the user to enter the number of the session to kill. It then uses `kill -9` to terminate the session.

### Reset Firewall to Defaults

```python
elif choice == "7":
    print("Resetting firewall back to default ports (80)")
    print("Resetting UFW")
    os.system("ufw reset")
    os.system("ufw allow 80")
    os.system("sudo ufw default deny outgoing")
    os.system("sudo ufw default deny incoming")
    os.system("ufw enable")
```

- **Purpose**: This block resets the firewall to default settings, allowing only port 80.
- **Explanation**: It uses `ufw` commands to reset the firewall, allow port 80, and deny all other incoming and outgoing traffic. It then enables the firewall.

### Set Up a TFTP Server

```python
elif choice == "8":
    tftp = raw_input("Install tftp? y/n: ")
    if tftp.lower() == "y":
        print("Installing tftp")
        os.system("sudo apt-get install tftpd-hpa -y")
        edit = raw_input("Clearing /etc/default/tftpd-hpa in 10 seconds ")
        time.sleep(10)
        os.system('echo TFTP_USERNAME="tftp" >> /etc/default/tftpd-hpa')
        os.system('echo TFTP_DIRECTORY="/var/lib/tftpboot" >> /etc/default/tftpd-hpa')
        os.system('echo TFTP_ADDRESS="0.0.0.0:69" >> /etc/default/tftpd-hpa')
        os.system('echo TFTP_OPTIONS="--secure" >> /etc/default/tftpd-hpa')
        os.system("sudo chmod -R 755 /var/lib/tftpboot/")
        os.system("sudo chown -R tftp:tftp /var/lib/tftpboot/")
        os.system("sudo ufw deny 69/udp")
        os.system("sudo ufw allow 69/tcp")
        os.system("sudo service tftpd-hpa restart")
```

- **Purpose**: This block sets up a TFTP server.
- **Explanation**: It prompts the user to confirm the installation of `tftpd-hpa`. If confirmed, it installs the package, configures the TFTP settings, sets appropriate permissions, and restarts the TFTP service.

## Example Usage

1. **Save the Script**: Save the script to a file, for example, `network_management.py`.
2. **Make the Script Executable**:
   ```bash
   chmod +x network_management.py
   ```
3. **Run the Script**:
   ```bash
   ./network_management.py
   ```
4. **Follow the Prompts**: The script will display a menu of options. Enter the number corresponding to the task you want to perform and follow the prompts.

## Conclusion

This script is a comprehensive tool for managing various network and system configurations. It provides a user-friendly interface for performing tasks such as listing active connections, managing cron jobs, stopping services, and setting up a TFTP server. By following the steps outlined in this document, you can effectively use the script to manage your system and enhance its security.
</details>
