# define GCP project name
variable "data_ingestion_project_id" {
  description = "The ID of the project in which the data ingestion resources will be created."
  type        = string
}

# define GCP region
variable "data_ingestion_project_region" {
  type        = string
  description = "project region"
}