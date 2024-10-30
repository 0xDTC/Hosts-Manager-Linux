# Manage Hosts Script

This bash script provides a convenient way to manage entries in your `/etc/hosts` file. It allows you to add, update, append, and remove host entries while preserving default localhost configurations.

## Features

- **Add New Host**: Add a new IP-hostname pair to `/etc/hosts`.
- **Update Host IP**: Update the IP of an existing host entry, preserving any associated sub-hostnames.
- **Append Sub-hostname**: Append additional sub-hostnames to existing IP entries.
- **Remove Entry**: Remove a specified host entry from `/etc/hosts`.
- **Wipe All User-Added Entries**: Remove all entries except default localhost entries, with multiple confirmation steps to prevent accidental deletion.

## Installation for Direct Terminal Access

After downloading and making the script executable, you can move it to `/usr/bin` to run it from anywhere in the terminal:

```bash
chmod +x manage-hosts
sudo mv manage-hosts /usr/bin/
```

Now, you can run the script from any directory by typing:

```bash
manage-hosts
```

## Usage

Run the script to display a menu with the following options:

```bash
manage-hosts
```

### Menu Options

When run, the script displays a menu with the following options:

1. **Add New Host**: Adds a new IP and hostname pair to `/etc/hosts`.
2. **Update Existing Host IP**: Allows you to update the IP address for an existing hostname entry, keeping associated sub-hostnames intact.
3. **Append Sub-hostname**: Adds a sub-hostname to an existing entry without altering the IP or primary hostname.
4. **Remove an Entry**: Removes a specific host entry.
5. **Wipe All Non-Localhost Entries**: Deletes all entries in `/etc/hosts` except the default entries (e.g., `localhost`). **Multiple confirmations** are required for safety.

### Example Workflow

```plaintext
Select an option (1-5): 2
User-added entries:

1 10.10.11.25 greenhorn.htb
2 10.10.11.23 permx.htb lms.permx.htb
...
Choose an entry by number to update its IP:
```

This example shows how the user is prompted to choose an existing host entry by its number for updating its IP.

## Default Entries Preserved

The following default entries are preserved during a wipe:

```plaintext
127.0.0.1       localhost
127.0.1.1       kali
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
```

These entries are excluded from deletion in option 5, ensuring your system’s core networking functions remain intact.

## Confirmation Process for Wiping Entries

When selecting the option to wipe all non-localhost entries, you will go through a series of prompts to confirm the deletion, providing a safeguard against unintended data loss.

## Requirements

- **Root Privileges**: Editing `/etc/hosts` requires root access.
- **Bash**: This script is compatible with Bash.

## Notes

- **Color Codes**: Colored output for easy readability, with each menu option highlighted differently.
- **Safe Deletion**: Wipe functionality carefully preserves essential system entries, making it safe to remove custom entries without affecting critical localhost configurations.