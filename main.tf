resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

resource "google_storage_bucket" "static" {
  name          = var.bucket_name
  location      = var.region
  storage_class = "STANDARD"
}
