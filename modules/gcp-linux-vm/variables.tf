# gcp-vm-project/modules/gcp-linux-vm/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources."
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy the VM."
  type        = string
}

variable "instance_count" {
  description = "Number of VM instances to create."
  type        = number
}

variable "machine_type" {
  description = "Machine type for the VM instance."
  type        = string
}

variable "image" {
  description = "Google Compute Engine image for the VM."
  type        = string
}

variable "ssh_user" {
  description = "Username for SSH access."
  type        = string
}

# REMOVED: ssh_public_key_path variable.

variable "ssh_public_key_path" { # RE-ADDED: Path to the SSH public key file
  description = "Path to the SSH public key file."
  type        = string
}