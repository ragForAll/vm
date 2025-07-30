# gcp-vm-project/outputs.tf

output "vm_external_ips" {
  description = "List of external IP addresses of the created VM instances."
  value       = module.gcp_linux_vms.vm_external_ips
}

output "vm_instance_names" {
  description = "List of names of the created VM instances."
  value       = module.gcp_linux_vms.vm_instance_names
}   