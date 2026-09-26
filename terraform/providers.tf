terraform {
  required_version = ">=1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "gcs" {
    bucket  = "otel-gek-tfstate-veera"
    prefix  = "terraform/state"
  }
}

provider "google"  {
  project = var.project_id
  region  = var.region

  impersonate_service_account = var.terraform_sa_email
  }
