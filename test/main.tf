module "dataops-system-design" {
  source      = "../../doctolib-system-design"
  data_ingestion_project_id = var.data_ingestion_project_id
  ressource_location = var.data_ingestion_project_region
  labels          = { environment = "dev" }
}