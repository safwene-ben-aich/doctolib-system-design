# doctolib-system-design
Assessment for data ops design system - 2

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.my_dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_table.my_table](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_dataflow_job.gcs_to_bq](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataflow_job) | resource |
| [google_project_service.bigquery_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.cloud_storage_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.dataflow_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_storage_bucket.appointments_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.dead_letter_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.appointments_ndjson](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [google_storage_bucket_object.appointments_schema](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [google_storage_bucket_object.transform_js](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.wait_for_apis](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_class"></a> [bucket\_class](#input\_bucket\_class) | Bucket storage class. | `string` | `"STANDARD"` | no |
| <a name="input_bucket_lifecycle_rules"></a> [bucket\_lifecycle\_rules](#input\_bucket\_lifecycle\_rules) | List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches\_storage\_class should be a comma delimited string. | <pre>list(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = any<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.<br>    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    condition = any<br>  }))</pre> | <pre>[<br>  {<br>    "action": {<br>      "type": "Delete"<br>    },<br>    "condition": {<br>      "age": 30,<br>      "matches_storage_class": "STANDARD",<br>      "with_state": "ANY"<br>    }<br>  }<br>]</pre> | no |
| <a name="input_data_ingestion_project_id"></a> [data\_ingestion\_project\_id](#input\_data\_ingestion\_project\_id) | The ID of the project in which the data ingestion resources will be created. | `string` | n/a | yes |
| <a name="input_delete_contents_on_destroy"></a> [delete\_contents\_on\_destroy](#input\_delete\_contents\_on\_destroy) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) Labels attached to Data Warehouse resources. | `map(string)` | `{}` | no |
| <a name="input_path_local_DS_data"></a> [path\_local\_DS\_data](#input\_path\_local\_DS\_data) | The path of local data sets for appoitements | `string` | `"data/extended_appointments.ndjson"` | no |
| <a name="input_path_local_DS_function"></a> [path\_local\_DS\_function](#input\_path\_local\_DS\_function) | The path of local schemas for appoitements | `string` | `"scripts/transform.js"` | no |
| <a name="input_path_local_DS_schema"></a> [path\_local\_DS\_schema](#input\_path\_local\_DS\_schema) | The path of local schemas for appoitements | `string` | `"schemas/appointments_schema.json"` | no |
| <a name="input_ressource_location"></a> [ressource\_location](#input\_ressource\_location) | Ressource location. | `string` | `"US"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->