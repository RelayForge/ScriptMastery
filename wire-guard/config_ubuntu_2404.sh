#! /bin/bash
# Set vars
internal_ip="192.168.1.1/24"
internal_subnets="192.168.1.0/24, 192.168.0.0/24"
external_ip="8.8.8.8"
port="51820"
# Generate keys
wg genkey | sudo tee /etc/wireguard/server_private.key | wg pubkey | sudo tee /etc/wireguard/server_public.key
wg genkey | sudo tee /etc/wireguard/client_private.key | wg pubkey | sudo tee /etc/wireguard/client_public.key
# Set key permissions
sudo chmod go= /etc/wireguard/server_private.key
sudo chmod go= /etc/wireguard/server_public.key
sudo chmod go= /etc/wireguard/client_private.key
sudo chmod go= /etc/wireguard/client_public.key
# Load keys
server_private_key=$(cat /etc/wireguard/server_private.key)
server_public_key=$(cat /etc/wireguard/server_public.key)
client_private_key=$(cat /etc/wireguard/client_private.key)
client_public_key=$(cat /etc/wireguard/client_public.key)
# Write server config
cat > "/etc/wireguard/wg0.conf" << EOF
[Interface]
PrivateKey = $server_private_key
Address = $internal_ip
ListenPort = $port
SaveConfig = true

[Peer]
PublicKey = $client_public_key
AllowedIPs = $internal_subnets
EOF

# write_log "success" "config script for $os_family $os_version executed successfully." "$log_file"