terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  backend "gcs" {
    bucket = "ocp-on-gcp-476018-tfstate"
    prefix = "tfstate/"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
