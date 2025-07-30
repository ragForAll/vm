# gcp-vm-project/variables.tf

variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "gcp_region" {
  description = "The GCP region to deploy resources."
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "The GCP zone to deploy the VM."
  type        = string
  default     = "us-central1-a"
}

variable "instance_count" {
  description = "Number of VM instances to create."
  type        = number
  default     = 1
}

variable "vm_machine_type" {
  description = "Machine type for the VM instance (e.g., e2-medium, n1-standard-1)."
  type        = string
  default     = "e2-medium"
}

variable "vm_image" {
  description = "Google Compute Engine image for the VM (e.g., ubuntu-os-cloud/ubuntu-2404-lts)."
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}

variable "ssh_user" {
  description = "Username for SSH access."
  type        = string
}

# REMOVED: ssh_public_key_path variable. SSH access will rely solely on password.

variable "ssh_public_key_path" { # RE-ADDED: Path to the SSH public key file
  description = "Path to the SSH public key file (~/.ssh/id_rsa.pub)."
  type        = string
} 