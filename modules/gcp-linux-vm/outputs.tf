# gcp-vm-project/modules/gcp-linux-vm/outputs.tf
output "vm_external_ips" {
  description = "List of external IP addresses of the created VM instances."
  value       = google_compute_instance.vm_instance[*].network_interface[0].access_config[0].nat_ip
}

output "vm_instance_names" {
  description = "List of names of the created VM instances."
  value       = google_compute_instance.vm_instance[*].name
}