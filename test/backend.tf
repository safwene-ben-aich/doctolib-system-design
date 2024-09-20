terraform {
  required_version = ">= 0.12"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.3.0"
    }
  }
  backend "gcs" {
    bucket = "docto-design-system"
    prefix    = "state/terraform.tfstate"
  }
}

# Configure the GCP Provider
provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
}