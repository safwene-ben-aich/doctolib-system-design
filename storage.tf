/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "data_ingestion_bucket" {

  project         = var.data_ingestion_project_id
  labels          = var.labels
  name            = "bkt-${var.data_ingestion_project_id}-${var.bucket_name}-${random_id.suffix.hex}"
  location        = var.bucket_location
  storage_class   = var.bucket_class
  
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
  force_destroy   = var.delete_contents_on_destroy
}

//Uploading the CSV file to the GCS bucket 

resource "google_storage_bucket_object" "appointments_data" {
  name   = "appointments.csv"
  bucket = google_storage_bucket.data_ingestion_bucket.name
  source = var.path_local_DS_data
}
resource "google_storage_bucket_object" "appointments_schema" {
  name   = "appointments.json"
  bucket = google_storage_bucket.data_ingestion_bucket.name
  source = var.path_local_DS_schema
}