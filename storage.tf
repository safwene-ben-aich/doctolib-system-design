#test

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "appointments_bucket" {
  name          = "my-dataflow-bucket-${random_id.suffix.hex}"
  project = var.data_ingestion_project_id
  location      = var.ressource_location
  force_destroy = true  # Allow Terraform to delete the bucket if there are objects

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 30  # Delete objects after 30 days
    }
  }
}

# Upload the appointments NDJSON file to the 'data' folder in the bucket
resource "google_storage_bucket_object" "appointments_ndjson" {
  name   = "data/appointments.ndjson"
  bucket = google_storage_bucket.appointments_bucket.name
  source = "data/extended_appointments.ndjson"  # Replace with your local path
}

# Upload the schema JSON file to the 'schemas' folder in the bucket
resource "google_storage_bucket_object" "appointments_schema" {
  name   = "schemas/appointments_schema.json"
  bucket = google_storage_bucket.appointments_bucket.name
  source = "schemas/appointments_schema.json"  # Replace with your local path
}

resource "google_storage_bucket_object" "transform_js" {
  name   = "scripts/transform.js"  # Path where the JS file will be stored in GCS
  bucket = google_storage_bucket.appointments_bucket.name
  source = "scripts/transform.js"  # Path to your local JS file
}