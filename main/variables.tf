variable "project_id" {
  description = "GCP project ID where VMs will be created"
  default     = "devops-497707"
}

variable "region" {
  description = "GCP region for VM resources"
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for VM creation"
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Name of the VPC network to create"
  default     = "devops-network"
}

variable "subnet_cidr" {
  description = "CIDR range for the VPC subnetwork"
  default     = "10.0.0.0/16"
}

variable "ansible_worker_count" {
  description = "Number of Ansible worker VMs to create"
  default     = 2
}

variable "target_count" {
  description = "Number of target VMs to create"
  default     = 6
}

variable "ansible_machine_type" {
  description = "Machine type for Ansible worker VMs"
  default     = "e2-medium"
}

variable "target_machine_type" {
  description = "Machine type for target VMs"
  default     = "e2-small"
}

variable "image_family" {
  description = "Image family for the VM boot disk"
  default     = "ubuntu-2204-lts"
}

variable "image_project" {
  description = "Project that contains the VM image family"
  default     = "ubuntu-os-cloud"
}

variable "ssh_keys" {
  description = "SSH public key metadata for VM access"
  type        = string
  default     = ""
}

variable "master_private_key" {
  description = "Private SSH key installed on master nodes for SSH access to targets"
  type        = string
  default     = ""
}

variable "startup_script" {
  description = "Startup script for bootstrapping VMs"
  type        = string
  default = <<-EOF
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get upgrade -y
    EOF
}
