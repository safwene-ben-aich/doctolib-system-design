terraform {
  required_version = ">= 0.13"
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "5.44.0"
    }
  }

  backend "gcs" {
    bucket = "docto-design-system-10"
    prefix    = "state/terraform.tfstate"
  }
}

# Configure the GCP Provider
provider "google" {
  project     = var.data_ingestion_project_id
  region      = var.data_ingestion_project_region
}