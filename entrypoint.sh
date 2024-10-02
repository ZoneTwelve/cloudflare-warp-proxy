#!/bin/bash

# Paths
HOST_MDM_XML="/mdm-data/mdm.xml"
CONTAINER_MDM_XML="/var/lib/cloudflare-warp/mdm.xml"

# Check if mdm.xml exists in the mounted directory
if [ -f "$HOST_MDM_XML" ]; then
    echo "Found mdm.xml in mounted directory. Copying to /var/lib/cloudflare-warp/"
    cp "$HOST_MDM_XML" "$CONTAINER_MDM_XML"
else
    echo "No mdm.xml found in mounted directory. Generating mdm.xml from environment variables."
    # Create mdm.xml with the provided environment variables
    cat <<EOF > "$CONTAINER_MDM_XML"
<dict>
  <key>organization</key>
  <string>${organization}</string>
  <key>auth_client_id</key>
  <string>${auth_client_id}</string>
  <key>auth_client_secret</key>
  <string>${auth_client_secret}</string>
  <key>warp_connector_token</key>
  <string>${warp_connector_token}</string>
</dict>
EOF
fi

# Apply iptables configuration if available
if [ -f /etc/iptables.rules ]; then
    iptables-restore < /etc/iptables.rules
    echo "Applied iptables rules from /etc/iptables.rules"
else
    echo "No iptables rules found at /etc/iptables.rules"
fi

# Start the WARP service in the background
warp-svc &

# Wait for the service to start
sleep 5

# Optionally, check the status
warp-cli status

# Keep the container running
tail -f /dev/null

