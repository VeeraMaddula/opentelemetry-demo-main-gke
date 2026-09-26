# ---vpc---
resource "google_compute_network" "vpc" {
    name                    = "${var.cluster_name}-vpc"
    auto_create_subnetworks = false
}

# ---subnet with secondary range for pods and services---
resource "google_compute_subnetwork" "subnet" {
    name          = "${var.cluster_name}-subnet"
    ip_cidr_range = "10.10.0.0/20"
    region        = var.region
    network       = google_compute_network.vpc.id

    secondary_ip_range {
        range_name    = "pods"
        ip_cidr_range = "10.20.0.0/14"
    }
    secondary_ip_range {
        range_name    = "services"
        ip_cidr_range = "10.24.0.0/20"
    }
}

# ---gke cluster---
resource "google_container_cluster" "primary" {
    name               = var.cluster_name
    location           = var.zone


    network            = google_compute_network.vpc.id
    subnetwork         = google_compute_subnetwork.subnet.id

    #we manage node pools separately
    remove_default_node_pool = true
    initial_node_count       = 1
     

    ip_allocation_policy {
        cluster_secondary_range_name  = "pods"
        services_secondary_range_name = "services"
    }

    workload_identity_config {
        workload_pool = "${var.project_id}.svc.id.goog"
    }

}

# ---node pool---
resource "google_container_node_pool" "general" {
    name      = "general-pool"
    location   = var.zone
    cluster    = google_container_cluster.primary.name

    node_config {
        machine_type = var.machine_type
        disk_size_gb = 50
        disk_type    = "pd-standard"
        service_account = var.terraform_sa_email


        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
        ]

        workload_metadata_config {
            mode = "GCE_METADATA"
        }

        labels = {
            environment = "demo"
             project = "otel"
        }
     
    }
}

# ---outputs---
output "cluster_name" {
    value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
    value = google_container_cluster.primary.endpoint
    sensitive = true
}
output "cluster_location" {
    value = google_container_cluster.primary.location
}