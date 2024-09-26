
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

