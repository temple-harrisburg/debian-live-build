#!/bin/sh
#
# Add a static IPv4 connection for use with the
# Kramer controller automation system
#

in-target /bin/sh << 'EOF'
CONNECTION_ID="kramer"
CONNECTION_ADDRESS="192.168.0.5/16"
CONNECTION_GATEWAY="192.168.0.1"

# Get the name of the ethernet interface
CONNECTION_INTERFACE=$(
	nmcli --get-value DEVICE,TYPE device | \
	awk -F : \'/ethernet/{ print $1 }\'
)

nmcli connection add \
	connection.type 			"802-3-ethernet" \
	connection.interface-name	"${CONNECTION_INTERFACE}" \
	connection.id				"${CONNECTION_ID}" \
	connection.autoconnect		"yes" \
	ipv4.method 				"manual" \
	ipv4.addresses  			"${CONNECTION_ADDRESS}" \
	ipv4.gateway				"${CONNECTION_GATEWAY}" \
	ipv4.dns					"${CONNECTION_GATEWAY}"
EOF
