
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