#!/bin/bash

# Function to route and execute the appropriate installation script
# Parameters:
#   1. Prefix for the script (e.g., install, setup, configure)
#   2. OS family
#   3. OS version
os_router() {
    local prefix=$1
    local os_family=$2
    local os_version=$3
    
    # Format the OS family and version for script naming (e.g., ubuntu_2204)
    os_family_lower=$(echo "$os_family" | tr '[:upper:]' '[:lower:]')
    os_version_nodot=$(echo "$os_version" | tr -d '.')

    # Construct the script name based on the prefix, OS family, and version
    script_name="${prefix}_${os_family_lower}_${os_version_nodot}.sh"

    # Check if the script exists
    if [ -f "$script_name" ]; then
        echo "[${script_name}] Executing $script_name..."
        
        # Make the script executable and run it, while prefixing the output
        chmod +x "$script_path"
        ./"$script_path" | while IFS= read -r line; do
            echo "[${script_name}] $line"
        done
    else
        echo "[${script_name}] Error: Script $script_name not found!"
        return 1
    fi
}
