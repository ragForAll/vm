# gcp-vm-project/backend.tf

terraform {
  backend "gcs" {

    bucket = "automations-466723-terraform-state"
    prefix = "terraform/state" # Path for your state files within the bucket
  }
}

# Google Cloud Provider configuration for the VM resources
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}