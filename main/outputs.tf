output "ansible_worker_names" {
  description = "Names of the Ansible worker VMs"
  value       = google_compute_instance.ansible_worker[*].name
}

output "ansible_worker_ips" {
  description = "External IPs of the Ansible worker VMs"
  value       = [for vm in google_compute_instance.ansible_worker : vm.network_interface[0].access_config[0].nat_ip]
}

output "target_names" {
  description = "Names of the target VMs"
  value       = google_compute_instance.target[*].name
}

output "target_ips" {
  description = "External IPs of the target VMs"
  value       = [for vm in google_compute_instance.target : vm.network_interface[0].access_config[0].nat_ip]
}
