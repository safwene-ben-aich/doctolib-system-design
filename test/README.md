# Marketplace Infrastructure as Code (IaC)
This repository contains Terraform configurations that can be used to deploy the infrastructure of the system design data lake.


<!-- BEGIN_TF_DOCS -->



## Prerequisites
Make sure you have installed all of the following prerequisites on your development machine:

* Git - [Download & Install Git](https://git-scm.com/downloads). OSX and Linux machines typically have this already installed.
 * [Terraform](https://www.terraform.io/downloads.html) >= 1.4.6.
* The [Gcloud CLI](https://cloud.google.com/sdk/gcloud#download_and_install_the) installed.

* Your GCP credentials are [configured](https://cloud.google.com/sdk/gcloud/reference/auth/login) locally.


## Configuring your Terraform backend

Make sure you have created and configured your backend if you are using the remote state mechanism.

```
terraform {
  required_version = ">= 0.12"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.3.0"
    }
  }
  backend "gcs" {
    bucket = "docto-design-system"
    prefix    = "state/terraform.tfstate"
  }
}
```
## Plan your terraform ressources

```
terraform plan -var sa_key_path="PATH_SA_FILE.json"
```

## Apply your terraform ressources

```
terraform apply -var sa_key_path="PATH_SA_FILE.json"
```

## Destroy your terraform ressources

```
terraform destroy -var sa_key_path="PATH_SA_FILE.json"
```


<!-- END_TF_DOCS -->