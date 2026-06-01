provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_compute_image" "ubuntu" {
  family  = var.image_family
  project = var.image_project
}

locals {
  ansible_worker_startup_script = <<-EOF
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get upgrade -y

    mkdir -p /home/ubuntu/.ssh
    cat > /home/ubuntu/.ssh/id_rsa <<-KEY
${var.master_private_key}
KEY
    chmod 400 /home/ubuntu/.ssh/id_rsa
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF
}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.required_apis["compute.googleapis.com"]
  ]
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.default.id
}

resource "google_compute_firewall" "allow_ssh_icmp" {
  name    = "${var.network_name}-allow-ssh-icmp"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vm-allow-ssh"]
}

resource "google_compute_instance" "ansible_worker" {
  count        = var.ansible_worker_count
  name         = "ansible-worker-${count.index + 1}"
  machine_type = var.ansible_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  tags = ["ansible-worker", "vm-allow-ssh"]

  metadata = var.ssh_keys == "" ? {} : {
    ssh-keys = var.ssh_keys
  }

  metadata_startup_script = local.ansible_worker_startup_script

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_instance" "target" {
  count        = var.target_count
  name         = "target-vm-${count.index + 1}"
  machine_type = var.target_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  tags = ["target-vm", "vm-allow-ssh"]

  metadata = var.ssh_keys == "" ? {} : {
    ssh-keys = var.ssh_keys
  }

  metadata_startup_script = var.startup_script

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
