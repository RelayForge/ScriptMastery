#! /bin/bash
# Set initial variables
product_name="wire-guard"
config="./config.yaml"
log_file="../logs/execution.log"
# Load helper functions
source ../helpers/write_log.sh
source ../helpers/generate_log_file_name.sh
source ../helpers/check_and_install_yq.sh
source ../helpers/check_supported_os.sh
source ../helpers/os_router.sh
# Generate the log file name
log_file=$(generate_log_file_name "$product_name")
# Check and install yq if necessary
check_and_install_yq
if check_os_support "$config"; then
    echo "OS Family: $os_family, OS Version: $os_version are supported."
    # Define the prefix you want to use, e.g., "install", "setup", etc.
    prefix="install"
    # Call the route_and_execute function with the prefix, OS family, and version
    # os_router "$prefix" "$os_family" "$os_version"
    # Call the os_routere function with the prefix, OS family, version, and log file
    if os_router "$prefix" "$os_family" "$os_version" "$log_file"; then
        write_log "success" "$prefix script for $os_family $os_version executed successfully." "$log_file"
    else
        write_log "error" "$prefix script for $os_family $os_version failed to execute." "$log_file"
    fi
else
    write_log "error" "OS Family: $os_family, OS Version: $os_version are not supported." "$log_file"
fi

else
    echo "OS Family: $os_family, OS Version: $os_version are not supported."
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