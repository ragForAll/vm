# gcp-vm-project/main.tf

# This project calls the VM module; it does not create the backend bucket itself.
module "gcp_linux_vms" {
  source = "./modules/gcp-linux-vm" # Path to your existing VM submodule

  project_id          = var.gcp_project_id
  region              = var.gcp_region
  zone                = var.gcp_zone
  instance_count      = var.instance_count
  machine_type        = var.vm_machine_type
  image               = var.vm_image
  ssh_user            = var.ssh_user
  ssh_public_key_path = var.ssh_public_key_path
}