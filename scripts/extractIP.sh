#!/bin/bash

# Exit immediately if any command fails.
set -e

# --- Determine Script and Terraform Root Directories ---
# SCRIPT_DIR is the directory where this script is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


TERRAFORM_ROOT_DIR="$SCRIPT_DIR/.." 

# --- Configuration ---
# Name of the Terraform output variable that provides the VM's external IP(s).
# Ensure this output exists in your Terraform configuration (e.g., in outputs.tf).
TERRAFORM_IP_OUTPUT_NAME="vm_external_ips" 

# --- Main Script Logic ---

echo "🛰️  Getting the external IP of the virtual machine from '$TERRAFORM_ROOT_DIR'..."

# Extract the IP from Terraform output, specifying the Terraform root directory.
# 'jq -r '.[0]'' extracts the first element of the JSON array.
IP=$(terraform -chdir="$TERRAFORM_ROOT_DIR" output -json "$TERRAFORM_IP_OUTPUT_NAME" | jq -r '.[0]')

# Validate the extracted IP.
if [ -z "$IP" ] || [ "$IP" == "null" ]; then
  echo "❌ Error: Could not get the IP address from Terraform output '$TERRAFORM_IP_OUTPUT_NAME'."
  echo "Ensure your Terraform configuration in '$TERRAFORM_ROOT_DIR' has this output and it contains a valid IP."
  # Use 'exit 1' instead of 'return 1' for standalone scripts. 'return' is for functions.
  exit 1 
fi

# Set IP as an environment variable.
# For the variable to persist in the calling shell, you would need to 'source' this script.
export IP="${IP}"
echo "✅ Environment variable exported successfully: IP=${IP}"
echo "You can now use this IP as '$IP'."