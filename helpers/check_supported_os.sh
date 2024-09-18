# File: ../helpers/check_supported_os.sh

#!/bin/bash

# Function to check if the OS is supported based on the given YAML path
check_os_support() {
  local yaml_file=$1

  # Ensure yq is installed
  if ! command -v yq &> /dev/null; then
      echo "yq is not installed. Please install yq to continue."
      return 1
  fi
  
  # Read OS information from the current system
  os_family=$(grep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
  os_version=$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

  # Use yq to extract supported versions for the given OS family from the YAML
  supported_versions=$(yq e ".supported_os[] | select(.family == \"$os_family\") | .versions[]" "$yaml_file")

  # Check if the OS family is supported
  if [[ -n "$supported_versions" ]]; then
      # Check if the current OS version is in the list of supported versions
      if echo "$supported_versions" | grep -q "$os_version"; then
          return 0  # Supported
      else
          return 1  # Version not supported
      fi
  else
      return 1  # Family not supported
  fi
}