#!/bin/bash

# Exit immediately if any command fails.
set -e

# --- Determine Script and Terraform Root Directories ---
# SCRIPT_DIR is the directory where this script is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TERRAFORM_ROOT_DIR="$SCRIPT_DIR/.." 

# --- Configuration ---
# Define a resource to check for existence in Terraform state.
# Set this to a specific resource address (e.g., "aws_vpc.main_vpc").
# If left empty, the 'apply' step will always run.
RESOURCE_TO_CHECK="" 

# --- Functions ---

# Checks if a resource exists in Terraform state within the specified root directory.
check_resource_exists() {
    local resource_address=$1
    echo "🔍 Checking for '$resource_address' in state within '$TERRAFORM_ROOT_DIR'..."
    if terraform -chdir="$TERRAFORM_ROOT_DIR" state show "$resource_address" &> /dev/null; then
        echo "✅ Resource found. Infrastructure likely deployed."
        return 0 
    else
        echo "❌ Resource not found. Proceeding with deployment."
        return 1 
    fi
}

# --- Main Script Logic ---

echo "🚀 Starting Terraform process in '$TERRAFORM_ROOT_DIR'..."

echo "Initializing Terraform..."
terraform -chdir="$TERRAFORM_ROOT_DIR" init

# Check if the specified resource already exists before proceeding to apply.
if [ -n "$RESOURCE_TO_CHECK" ] && check_resource_exists "$RESOURCE_TO_CHECK"; then
    echo "💡 Skipping 'terraform apply' as infrastructure appears to be already deployed."
    echo "✅ Terraform process completed."
    exit 0
elif [ -z "$RESOURCE_TO_CHECK" ]; then
    echo "⚠️ RESOURCE_TO_CHECK is not set. The script will proceed with 'terraform apply'."
fi

echo "🔄 Formatting code..."
terraform -chdir="$TERRAFORM_ROOT_DIR" fmt -recursive

echo "📝 Planning infrastructure..."
terraform -chdir="$TERRAFORM_ROOT_DIR" plan

echo "Applying changes (with auto-approval)..."
terraform -chdir="$TERRAFORM_ROOT_DIR" apply -auto-approve

# Verify if Terraform apply failed.
if [ $? -ne 0 ]; then
  echo "❌ Error: 'terraform apply' failed. Check Terraform logs."
  exit 1 
fi

echo "✅ Infrastructure deployed successfully."