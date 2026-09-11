#!/bin/sh
#
# Update the pre-defined Kramer Controller static configuration with the target machines' ethernet connection
#

# Use `chroot` instead of in-target because it was causing problems
chroot /target /bin/bash << 'EOF' || echo "Failed to find ethernet interface" >&2
CONNECTION_FILE="/etc/NetworkManager/system-connections/kramer.nmconnection"

# `nmcli` is not available, so retrieve the name of the Ethernet connection from the output of `ip`
CONNECTION_INTERFACE=$(ip addr | awk '/^[0-9]/{ sub(/:$/, "", $2); interface=$2; next }
{ if ($1 ~ /link\/ether/) print interface }')

# Insert the interface name in the pre-existing connection file
sed -i "s/\(interface-name=\)/\1${CONNECTION_INTERFACE}/" "${CONNECTION_FILE}"
EOF

# Make sure kramer.nmconnection has the correct permissions
CONNECTION_FILE="/preseed/profiles/automation_controller/etc/NetworkManager/system-connections/kramer.nmconnection"
sudo chown root:root "${CONNECTION_FILE}"
sudo chmod 600 "${CONNECTION_FILE}"
