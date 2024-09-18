# File: ../helpers/check_and_install_yq.sh

#!/bin/bash

# Function to check if yq is available and install it if not
check_and_install_yq() {
    if ! command -v yq &> /dev/null; then
        echo "yq is not installed. Installing yq..."
        sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
        sudo chmod +x /usr/bin/yq
        if command -v yq &> /dev/null; then
            echo "yq successfully installed."
        else
            echo "yq installation failed."
            return 1  # Return failure if installation fails
        fi
    else
        echo "yq is already installed."
    fi
}
