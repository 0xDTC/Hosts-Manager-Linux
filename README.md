# Hosts Manager Script

This Bash script is designed to manage entries in your `/etc/hosts` file conveniently. It provides options to add, update, append, and remove host entries, as well as wipe all user-added entries while preserving essential default localhost configurations.

## Features

- **Add New Host**: Add a new IP-hostname pair to `/etc/hosts` with consistent formatting.
- **Update Host IP**: Update the IP of an existing host entry, retaining associated sub-hostnames.
- **Append Sub-hostname**: Append additional sub-hostnames to existing IP entries.
- **Remove Entry**: Remove a specified host entry from `/etc/hosts`.
- **Wipe All User-Added Entries**: Remove all entries except default localhost entries, with confirmation steps to prevent accidental deletions.

## Installation for Direct Terminal Access

To run the script from any directory, you can move it to `/usr/bin`:

```bash
chmod +x manage-hosts
sudo mv manage-hosts /usr/bin/
```

Now you can execute the script from anywhere by typing:

```bash
manage-hosts
```

## Usage

Run the script to display a menu with available options:

```bash
sudo manage-hosts
```

### Menu Options

The script offers the following options:

1. **Add New Host**  
   - Adds a new IP and hostname pair to `/etc/hosts`.
   - If the IP already exists, it prompts you to use the "Append Sub-hostname" option.

2. **Update Existing Host IP**  
   - Updates the IP address for an existing hostname entry, preserving associated sub-hostnames.
   - Prompts you to choose an entry by number, and then asks for the new IP.

3. **Append Sub-hostname**  
   - Adds a sub-hostname to an existing entry without altering the primary IP or hostname.
   - Prompts you to select an entry by number, then allows you to add sub-hostnames until you return to the main menu.

4. **Remove an Entry**  
   - Removes a specific host entry from `/etc/hosts`.
   - Prompts you to select an entry by number, then removes it. You can continue removing entries or return to the main menu.

5. **Wipe All Non-Localhost Entries**  
   - Deletes all custom entries in `/etc/hosts` except for the default entries (e.g., `localhost`).
   - Provides a confirmation prompt to ensure safe deletion.

### Example Workflow

Upon running the script, you’ll see a menu like this:

```plaintext
1. Add new host
2. Update existing host IP
3. Append sub-hostname to an existing entry
4. Remove an existing entry
5. Wipe all non-localhost entries in /etc/hosts (Confirmation required)
Select an option (1-5):
```

Example usage for updating an IP address:

```plaintext
Select an option (1-5): 2
User-added entries:

1 10.10.11.25 greenhorn.htb
2 10.10.11.23 permx.htb lms.permx.htb

Choose an entry by number to update its IP (or press Enter to return to the main menu): 1
Enter the new IP address: 10.10.11.26
IP address updated for greenhorn.htb.
```

### Color-Coded Output
- **Green**: Add new host
- **Blue**: Update host IP
- **Yellow**: Append sub-hostname
- **Red**: Remove entry or display errors
- **Red Background**: Warning for wiping non-localhost entries

## Default Entries Preserved

The following default entries are always preserved and restored if missing:

```plaintext
127.0.0.1       localhost
127.0.1.1       kali
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
```

These entries are critical for system functionality and are protected from deletion.

## Confirmation Process for Wiping Entries

If you select the option to wipe all non-localhost entries, you will be prompted to confirm the deletion. This multi-step confirmation helps safeguard against accidental deletion of entries.

## Requirements

- **Root Privileges**: Modifying `/etc/hosts` requires root access.
- **Bash**: This script is compatible with the Bash shell.

## Notes

- **Color-Coded Output**: Each menu option and error message is color-coded for clarity.
- **Safety and Preservation**: The script prevents the deletion of essential system entries, ensuring safe modifications to your `/etc/hosts` file.