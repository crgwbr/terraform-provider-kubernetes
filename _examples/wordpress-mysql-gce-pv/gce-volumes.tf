variable "gce_region" {}
variable "gce_zone" {}

provider "google" {
  project = "hc-terraform-testing"
  region = "gce_region"
}

resource "google_compute_disk" "mysql" {
  name  = "wordpress-mysql"
  type  = "pd-ssd"
  zone  = "${var.gce_zone}"
  size = 20
}

resource "kubernetes_persistent_volume" "mysql" {
  metadata {
    name = "mysql-pv"
  }
  spec {
    capacity {
      storage = "20Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "${google_compute_disk.mysql.name}"
        fs_type = "ext4"
      }
    }
  }
}

resource "google_compute_disk" "wordpress" {
  name  = "wordpress-frontend"
  type  = "pd-ssd"
  zone  = "${var.gce_zone}"
  size = 20
}

resource "kubernetes_persistent_volume" "wordpress" {
  metadata {
    name = "wordpress-pv"
  }
  spec {
    capacity {
      storage = "20Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "${google_compute_disk.wordpress.name}"
        fs_type = "ext4"
      }
    }
  }
}

