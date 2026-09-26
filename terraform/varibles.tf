variable "project_id" {
    description = "The GCP project ID"
    type        = string
    default     = "otel-gke-obervability"
  
}

variable "region" {
    description = "The GCP region"
    type        = string
    default     = "us-east1"
}

variable "zone" {
    description = "The GCP zone"
    type        = string
    default     = "us-east1-b"
}

variable "cluster_name" {
    description = "The name of the GKE cluster"
    type        = string
    default     = "otel-gke-cluster"
}

variable "terraform_sa_email" {
    description = "The email of the service account to impersonate for Terraform"
    type        = string
    default     = "terraform-sa@otel-gke-obervability.iam.gserviceaccount.com"
}

variable "node_count" {
    description = "The number of nodes in the GKE cluster"
    type        = number
    default     = 2
}

variable "machine_type" {
    description = "The machine type for the GKE nodes"
    type        = string
    default     = "e2-standard-4"
}