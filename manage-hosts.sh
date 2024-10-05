#!/bin/bash

# Color codes
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RED_BG="\033[41m"
RESET="\033[0m"

# Function to display the usage menu with color
usage() {
  echo -e "${GREEN}1. Add new host${RESET}"
  echo -e "${BLUE}2. Append sub-hostname to an existing entry${RESET}"
  echo -e "${RED}3. Remove an existing entry${RESET}"
  echo -e "${RED_BG}4. Wipe all entries in /etc/hosts (Confirmation required)${RESET}"
}

# Function to display confirmation prompt
confirm_wipe() {
  read -p "Are you absolutely sure you want to wipe all entries? (y/n): " confirm1
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

# Function to wipe the /etc/hosts file
wipe_hosts() {
  if confirm_wipe; then
    sudo cp /dev/null /etc/hosts
    echo "/etc/hosts has been wiped."
  else
    echo "Operation canceled. No changes made to /etc/hosts."
  fi
}

# Function to list and remove an existing entry
remove_entry() {
  echo "Existing hosts:"
  # Use awk to preserve proper numbering
  awk '{print NR, $0}' /etc/hosts
  read -p "Choose an entry by number to remove: " number
  entry=$(awk "NR==$number" /etc/hosts)
  if [ -z "$entry" ]; then
    echo "Invalid selection. No such entry."
    return
  fi
  echo "You are about to remove the following entry: $entry"
  read -p "Are you sure you want to remove this entry? (y/n): " confirm
  if [[ "$confirm" == "y" ]]; then
    sudo sed -i "${number}d" /etc/hosts
    echo "Entry removed."
  else
    echo "Operation canceled."
  fi
}

# Main menu
usage
read -p "Select an option (1-4): " option

case $option in
  1)  # Add new host
    read -p "Provide IP: " ip
    read -p "Provide hostname: " hostname
    if grep -q "$ip" /etc/hosts; then
      echo "This IP already exists. Use option 2 to append a sub-hostname."
    else
      sudo sh -c "echo '$ip    $hostname' >> /etc/hosts"
      echo "New host added."
    fi
    ;;
  2)  # Append sub-hostname to an existing entry
    echo "Existing entries:"
    awk '{print NR, $0}' /etc/hosts
    read -p "Choose an entry by number: " number
    entry=$(awk "NR==$number" /etc/hosts)
    if [ -z "$entry" ]; then
      echo "Invalid selection. No such entry."
      exit 1
    fi
    read -p "Provide sub-hostname to append: " subhostname
    if grep -q "$subhostname" <<<"$entry"; then
      echo "Sub-hostname already exists in this entry."
    else
      sudo sed -i "${number}s/$/ $subhostname/" /etc/hosts
      echo "Sub-hostname appended."
    fi
    ;;
  3)  # Remove an existing entry
    remove_entry
    ;;
  4)  # Wipe all entries in /etc/hosts
    wipe_hosts
    ;;
  *)  # Invalid option
    echo "Invalid option. Please try again."
    ;;
esac
