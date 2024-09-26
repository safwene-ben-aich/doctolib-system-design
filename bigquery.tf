
# Create a BigQuery dataset
resource "google_bigquery_dataset" "my_dataset" {
  dataset_id = "appointments_dataset"
  project    = var.data_ingestion_project_id
  location   = var.ressource_location
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
