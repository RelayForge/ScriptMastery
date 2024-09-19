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