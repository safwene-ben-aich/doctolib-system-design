# module "dataops-system-design" {
#   source      = "../../doctolib-system-design"
#   data_ingestion_project_id = var.data_ingestion_project_id
#   labels          = { environment = "dev" }
#   bucket_name     = var.bucket_name
#   bucket_location = var.gcp_region
#   path_local_DS_data = var.path_local_DS_data
#   path_local_DS_schema = var.path_local_DS_schema
# }
# Create a Cloud Storage bucket for storing datasets and schemas


# Enable the Dataflow API
resource "google_project_service" "dataflow_api" {
  project = var.data_ingestion_project_id
  service = "dataflow.googleapis.com"
  disable_dependent_services=true
}

# Optionally, enable other APIs that are commonly used with Dataflow
resource "google_project_service" "bigquery_api" {
  project = var.data_ingestion_project_id
  service = "bigquery.googleapis.com"
  disable_dependent_services=true

}

resource "google_project_service" "cloud_storage_api" {
  project = var.data_ingestion_project_id
  service = "storage.googleapis.com"
  disable_dependent_services=true

}

# Add a sleep after enabling the Dataflow API to wait for it to be fully enabled
resource "time_sleep" "wait_for_apis" {
  depends_on = [google_project_service.dataflow_api,
                google_project_service.bigquery_api,
                google_project_service.cloud_storage_api]  # Wait until the Dataflow API is enabled
  create_duration = "60s"  # Adjust the sleep duration as needed
}



resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "appointments_bucket" {
  name          = "my-dataflow-bucket-${random_id.suffix.hex}"
  project = var.data_ingestion_project_id
  location      = var.gcp_region
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

resource "google_storage_bucket" "dead_letter_bucket" {
  name          = "my-dead-letter-bucket-${random_id.suffix.hex}"
  project = var.data_ingestion_project_id
  location      = var.gcp_region
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


# Output the bucket URL for use in Dataflow or other services
output "bucket_url" {
  value = google_storage_bucket.appointments_bucket.url
  description = "URL of the Cloud Storage bucket for storing appointments data and schema."
}

# Create a BigQuery dataset
resource "google_bigquery_dataset" "my_dataset" {
  dataset_id = "appointments_dataset"
  project    = var.data_ingestion_project_id
  location   = var.gcp_region
  depends_on = [time_sleep.wait_for_apis]  # Wait until APIs are enabled

}

# Create a BigQuery table where the data will be stored
resource "google_bigquery_table" "my_table" {
  dataset_id = google_bigquery_dataset.my_dataset.dataset_id
  table_id   = "appointments"
  project    = var.data_ingestion_project_id
  deletion_protection = false
  depends_on = [time_sleep.wait_for_apis]  # Wait until APIs are enabled
  
}

# Dataflow job to stream data from the Cloud Storage bucket to BigQuery
resource "google_dataflow_job" "gcs_to_bq" {
  
  name              = "gcs-to-bigquery-dataflow-job"
  template_gcs_path = "gs://dataflow-templates/latest/GCS_Text_to_BigQuery"  # Google-provided template for GCS -> BigQuery
  temp_gcs_location = "${google_storage_bucket.appointments_bucket.url}/temp"  # Temporary directory for Dataflow

  parameters = {
    javascriptTextTransformFunctionName = "transform"  # Optional if using transformation
    javascriptTextTransformGcsPath      = "${google_storage_bucket.appointments_bucket.url}/scripts/transform.js"  # Path to the JS file in GCS
    JSONPath  = "${google_storage_bucket.appointments_bucket.url}/schemas/appointments_schema.json"  # Path to the schema
    inputFilePattern = "${google_storage_bucket.appointments_bucket.url}/data/appointments.ndjson"
    outputTable      = "${var.data_ingestion_project_id}:${google_bigquery_dataset.my_dataset.dataset_id}.${google_bigquery_table.my_table.table_id}"
    bigQueryLoadingTemporaryDirectory =  "${google_storage_bucket.appointments_bucket.url}/temp"
  }
  

  on_delete = "cancel"  # Cancels the job if the Terraform resource is destroyed
}