terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "ocp-on-gcp-476018"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
