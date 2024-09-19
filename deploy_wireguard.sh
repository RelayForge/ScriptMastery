#! /bin/bash
# Set initial variables
package="wireguard"
config="./$package/config.yaml"
# Load helper functions
source ./helpers/write_log.sh
source ./helpers/check_requirements.sh
source ./helpers/check_os.sh
source ./helpers/execution_router.sh
# Check and install reuirements
check_requirements
# Router to execute main logic scripts
if check_os_support "$config"; then
    # Supported environment, continue
    write_log "success"  "OS Family: $os_family, OS Version: $os_version are supported for $package deployment." "$package" "$log_file"
    # Start install process
    execution_router "$package" "install" "$os_family" "$os_version" "$log_file"
    # Start configuration process
    execution_router "$package" "config" "$os_family" "$os_version" "$log_file"
else
    write_log "error" "OS Family: $os_family, OS Version: $os_version are not supported for $package deployment." "$package" "$log_file"
fi


# wg genkey | sudo tee /etc/wireguard/server_private.key | wg pubkey | sudo tee /etc/wireguard/server_public.key
# wg genkey | sudo tee /etc/wireguard/client_ops_private.key | wg pubkey | sudo tee /etc/wireguard/client_ops_public.key
# wg genkey | sudo tee /etc/wireguard/client_dev_private.key | wg pubkey | sudo tee /etc/wireguard/client_dev_public.key
# sudo chmod go= /etc/wireguard/server_private.key
# sudo chmod go= /etc/wireguard/server_public.key
# sudo chmod go= /etc/wireguard/client_ops_private.key
# sudo chmod go= /etc/wireguard/client_ops_public.key
# sudo chmod go= /etc/wireguard/client_dev_private.key
# sudo chmod go= /etc/wireguard/client_dev_public.key
# sudo cat /etc/wireguard/server_private.key

# vi /etc/wireguard/wg0.conf

# [Interface]
# PrivateKey = QOrI7ht13Xwax17pJ03rZaeiL5VLQEJMZ3B1HT4FA3Q=
# Address = 192.168.0.11/24
# ListenPort = 51820
# SaveConfig = true

# [Peer]
# PublicKey = yXk6b2fh2uwwD/gf2YZQUnWEzTzcOcosuF9GBdAVmGM=
# AllowedIPs = 192.168.0.0/24
# # AllowedIPs = 192.168.0.192/26
# Endpoint = 144.76.152.155:51820

# # vi client.conf

# [Interface]
# Address = 192.168.0.100/24
# PrivateKey = MCGcO0Wi+AEH6c3uohTqkVpF90VrFAzIrseXqNcqNEc=

# [Peer]
# PublicKey = HsfWzLeGOy+/46yeuE3ASHQAyBOfHwKs7Abre5dN/xI=
# Endpoint = 144.76.152.155:51820
# AllowedIPs = 0.0.0.0/0

# sudo ufw allow 51820/udp
# sudo systemctl enable wg-quick@wg0.service
# sudo systemctl start wg-quick@wg0.service
# sudo systemctl status wg-quick@wg0.service
# sudo systemctl restart wg-quick@wg0.service