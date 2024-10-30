#!/bin/bash

# Color codes
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
RED_BG="\033[41m"
RESET="\033[0m"

# Default entries to keep
DEFAULT_ENTRIES="127.0.0.1\s+localhost|127.0.1.1\s+kali|::1\s+localhost\s+ip6-localhost\s+ip6-loopback|ff02::1\s+ip6-allnodes|ff02::2\s+ip6-allrouters"

# Function to display the usage menu with color
usage() {
  echo -e "${GREEN}1. Add new host${RESET}"
  echo -e "${BLUE}2. Update existing host IP${RESET}"
  echo -e "${YELLOW}3. Append sub-hostname to an existing entry${RESET}"
  echo -e "${RED}4. Remove an existing entry${RESET}"
  echo -e "${RED_BG}5. Wipe all non-localhost entries in /etc/hosts (Confirmation required)${RESET}"
}

# Function to display confirmation prompt
confirm_wipe() {
  read -p "Are you absolutely sure you want to wipe all non-localhost entries? (y/n): " confirm1
  if [[ "$confirm1" == "y" ]]; then
    read -p "Are you really sure? (y/n): " confirm2
    if [[ "$confirm2" == "y" ]]; then
      read -p "Final confirmation. This action cannot be undone. Proceed? (y/n): " confirm3
      if [[ "$confirm3" == "y" ]]; then
        return 0  # User confirmed all three times
      fi
    fi
  fi
  return 1  # User did not confirm
}

# Function to wipe non-default entries in /etc/hosts
wipe_hosts() {
  if confirm_wipe; then
    sudo sed -i "/$DEFAULT_ENTRIES/!d" /etc/hosts
    echo -e "${RED}All non-localhost entries in /etc/hosts have been wiped.${RESET}"
  else
    echo "Operation canceled. No changes made to /etc/hosts."
  fi
}

# Function to update existing host IP while keeping sub-hostnames intact
update_host_ip() {
  echo -e "\nUser-added entries:\n"
  awk "/$DEFAULT_ENTRIES/ {next} {count++; print count, \$0}" /etc/hosts
  read -p "Choose an entry by number to update its IP: " number
  entry=$(awk "/$DEFAULT_ENTRIES/ {next} {count++} count==$number" /etc/hosts)

  if [ -z "$entry" ]; then
    echo "Invalid selection. No such entry."
    return
  fi

  echo "Current entry: $entry"
  read -p "Enter the new IP address: " new_ip

  # Get the hostname and any sub-hostnames from the selected entry
  hostnames=$(echo "$entry" | awk '{$1=""; print $0}' | sed 's/^[ \t]*//')
  sudo sed -i "s/^.*$entry\$/$new_ip $hostnames/" /etc/hosts
  echo "IP address updated for $hostnames."
}

# Function to list and remove an existing entry
remove_entry() {
  echo -e "\nUser-added entries:\n"
  awk "/$DEFAULT_ENTRIES/ {next} {count++; print count, \$0}" /etc/hosts
  read -p "Choose an entry by number to remove: " number
  entry=$(awk "/$DEFAULT_ENTRIES/ {next} {count++} count==$number" /etc/hosts)
  if [ -z "$entry" ]; then
    echo "Invalid selection. No such entry."
    return
  fi
  echo "You are about to remove the following entry: $entry"
  read -p "Are you sure you want to remove this entry? (y/n): " confirm
  if [[ "$confirm" == "y" ]]; then
    sudo sed -i "/$entry/d" /etc/hosts
    echo "Entry removed."
  else
    echo "Operation canceled."
  fi
}

# Main menu
usage
read -p "Select an option (1-5): " option

case $option in
  1)  # Add new host
    read -p "Provide IP: " ip
    read -p "Provide hostname: " hostname
    if grep -q "$ip" /etc/hosts; then
      echo "This IP already exists. Use option 3 to append a sub-hostname."
    else
      sudo sh -c "echo '$ip    $hostname' >> /etc/hosts"
      echo "New host added."
    fi
    ;;
  2)  # Update existing host IP
    update_host_ip
    ;;
  3)  # Append sub-hostname to an existing entry
    echo -e "\nUser-added entries:\n"
    awk "/$DEFAULT_ENTRIES/ {next} {count++; print count, \$0}" /etc/hosts
    read -p "Choose an entry by number: " number
    entry=$(awk "/$DEFAULT_ENTRIES/ {next} {count++} count==$number" /etc/hosts)
    if [ -z "$entry" ]; then
      echo "Invalid selection. No such entry."
      exit 1
    fi
    read -p "Provide sub-hostname to append: " subhostname
    if grep -q "$subhostname" <<<"$entry"; then
      echo "Sub-hostname already exists in this entry."
    else
      sudo sed -i "s/^$entry\$/$entry $subhostname/" /etc/hosts
      echo "Sub-hostname appended."
    fi
    ;;
  4)  # Remove an existing entry
    remove_entry
    ;;
  5)  # Wipe all non-localhost entries in /etc/hosts
    wipe_hosts
    ;;
  *)  # Invalid option
    echo "Invalid option. Please try again."
    ;;
esac
