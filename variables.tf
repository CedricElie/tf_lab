variable "project" {
  type        = string
  description = "GCP Project name"
  default     = "ocp-on-gcp-476018"
}

variable "region" {
  type        = string
  description = "GCP Region name"
  default     = "europe-west9"
}

variable "zone" {
  type        = string
  description = "GCP Zone name"
  default     = "europe-west9-a"
}

variable "vpc_name" {
  type        = string
  description = "GCP VPC Name"
  default     = "vpc-network-tf"
}

variable "bucket_name" {
  type        = string
  description = "Cloud storage bucket for tfstate"
  default     = "storage-bucket-476018"
}
