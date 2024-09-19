#! /bin/bash
# Source the helpers
source ./helpers/increment_ip.sh
source ./helpers/write_log.sh
# Set vars
yaml_file="./wireguard/config.yaml"
supported_versions=$(yq e ".supported_os[] | select(.family == \"$os_family\") | .versions[]" "$yaml_file")
internal_ip=$(yq e ".server[] | select(.internal_ip) | .internal_ip" "$yaml_file")
external_ip=$(yq e ".server[] | select(.external_ip) | .external_ip" "$yaml_file")
allowed_subnets=$(yq e ".server[] | select(.allowed_subnets) | .allowed_subnets" "$yaml_file")
client_subnet_start=$(yq e ".server[] | select(.client_subnet_start) | .client_subnet_start" "$yaml_file")
client_subnet_end=$(yq e ".server[] | select(.client_subnet_end) | .client_subnet_end" "$yaml_file")
client_count=$(yq e ".server[] | select(.client_count) | .client_count" "$yaml_file")
wg_port=$(yq e ".server[] | select(.wg_port) | .wg_port" "$yaml_file")
wg_path="/etc/wireguard"
wg_config_path="$wg_path/wg0.conf"
# Generate server keys
wg genkey | sudo tee $wg_path/server_private.key | wg pubkey | sudo tee $wg_path/server_public.key
# Set key permissions for server
sudo chmod go= $wg_path/server_private.key
sudo chmod go= $wg_path/server_public.key
# Load server keys
server_private_key=$(cat $wg_path/server_private.key)
server_public_key=$(cat $wg_path/server_public.key)
# Write server config
sudo cat > $wg_config_path << EOF
[Interface]
PrivateKey = $server_private_key
Address = $internal_ip
ListenPort = $wg_port
SaveConfig = true
EOF
# Start with the base client IP
current_client_ip=$client_subnet_start
# Loop through clients
for ((i=1; i<=client_count; i++)); do
    # Generate client keys for each client
    wg genkey | sudo tee $wg_path/client_private_$i.key | wg pubkey | sudo tee $wg_path/client_public_$i.key
    # Set key permissions for each client
    sudo chmod go= $wg_path/client_private_$i.key
    sudo chmod go= $wg_path/client_public_$i.key
    # Load client keys
    client_private_key=$(sudo cat $wg_path/client_private_$i.key)
    client_public_key=$(sudo cat $wg_path/client_public_$i.key)
    # Append client to server config
    sudo cat >> "/etc/wireguard/wg0.conf" << EOF

[Peer]
PublicKey = $client_public_key
AllowedIPs = $current_client_ip/32
EOF
    # Write each client's config
    sudo cat > "$wg_path/client_$i.conf" << EOF
[Interface]
PrivateKey = $client_private_key
Address = $current_client_ip/24

[Peer]
PublicKey = $server_public_key
AllowedIPs = $allowed_subnets
Endpoint = $external_ip:$wg_port
EOF
    # Increment client IP for the next client
    current_client_ip=$(increment_ip "$current_client_ip")
done
# Add rules to ufw
sudo ufw allow 51820/udp
# Set service startup mode
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
# Display success message
write_log "success"  "WireGuard server and $client_count clients have been configured." "$log_file"