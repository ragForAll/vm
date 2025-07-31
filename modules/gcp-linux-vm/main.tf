# gcp-vm-project/modules/gcp-linux-vm/main.tf

resource "google_compute_instance" "vm_instance" {
  count        = var.instance_count
  project      = var.project_id
  zone         = var.zone
  name         = "linux-vm-${count.index}"
  machine_type = var.machine_type
  boot_disk {
    initialize_params {
      image = var.image # Ubuntu 24.04 LTS AMD64
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Assign a public IP for external access
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }
  tags = ["ssh-access", "n8n-access", "qdrant-access"]
}

# Firewall rules remain unchanged
resource "google_compute_firewall" "ssh_firewall_rule" {
  project     = var.project_id
  name        = "allow-ssh-from-internet"
  network     = "default"
  description = "Allows SSH access from anywhere (0.0.0.0/0)"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-access"]
}

resource "google_compute_firewall" "n8n_firewall_rule" {
  project     = var.project_id
  name        = "allow-n8n-from-internet"
  network     = "default"
  description = "Allows n8n access (port 5678) from anywhere (0.0.0.0/0)"
  allow {
    protocol = "tcp"
    ports    = ["5678"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["n8n-access"]
}

resource "google_compute_firewall" "qdrant_firewall_rule" {
  project     = var.project_id
  name        = "allow-qdrant-from-internet"
  network     = "default"
  description = "Allows qdrant access from anywhere (0.0.0.0/0)"
  allow {
    protocol = "tcp"
    ports    = ["6333"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["qdrant-access"]
}