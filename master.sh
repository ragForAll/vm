#!/bin/bash

########################################################
# VM creation with Terraform                           #
########################################################

echo "🚀 Starting Terraform process..."
echo "Formatting the code..."
terraform fmt -recursive

echo "Planning the infrastructure..."
terraform plan

echo "Applying changes (with auto-approval)..."
terraform apply -auto-approve

# Verify if Terraform failed
if [ $? -ne 0 ]; then
  echo "❌ Error: 'terraform apply' failed. Check Terraform logs."
  return 1
fi

echo "✅ Infrastructure deployed successfully."
echo ""


########################################################
# Extract and set the virtual machine IP               #
########################################################

echo "🛰️  Getting the external IP of the virtual machine..."

# Setting IP as a variable
IP=$(terraform output -json vm_external_ips | jq -r '.[0]')

# Validate the extracted IP
if [ -z "$IP" ] || [ "$IP" == "null" ]; then
  echo "❌ Error: Could not get the IP address from Terraform output."
  echo "Ensure your Terraform configuration has an output named 'vm_external_ips'."
  return 1
fi

# Set IP as an environment variable
export URL="${IP}"
echo "✅ Environment variable exported successfully: URL=${URL}"
echo ""


########################################################
# Set the new IP in the Ansible inventory              #
########################################################

INVENTORY_FILE="../../ansible/n8n-ansible/inventory/hosts.ini"

# Verify if the inventory file exists
if [ ! -f "$INVENTORY_FILE" ]; then
    echo "❌ Error: Inventory file not found at: $INVENTORY_FILE"
    return 1
fi

sleep 3

# Use 'sed' to replace the line containing 'ansible_host' with the new IP.
# A backup of the original file is created with the .bak extension for safety.
sed -i.bak "s/ansible_host=[0-9.]\+/ansible_host=${IP}/" "$INVENTORY_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Error: Failed to update the inventory file with 'sed'."
  return 1
fi

echo "✅ '$INVENTORY_FILE' updated with the new IP."
echo ""


########################################################
# Execute Ansible playbooks and subsequent scripts     #
########################################################

echo "⚙️ Executing Ansible playbook..."
./../../ansible/n8n-ansible/execute.sh



########################################################
# Workflow creation scripts                            #
########################################################
# Path to the workflow creation script
WORKFLOW_SCRIPT_PATH="../../automation/workflowsCreation.sh"

# Verify if the script exists before trying to execute it
if [ ! -f "$WORKFLOW_SCRIPT_PATH" ]; then
    echo "❌ Error: Script at '$WORKFLOW_SCRIPT_PATH' not found."
    return 1
fi

echo "⚙️ Executing the workflow creation script..."
./${WORKFLOW_SCRIPT_PATH}

if [ $? -ne 0 ]; then
  echo "❌ Error: Execution of '$WORKFLOW_SCRIPT_PATH' failed."
  return 1
fi

echo "🎉 Process completed!"