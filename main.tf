terraform {
  backend "gcs" {

  }
}

#permission sa to bucket
resource "google_storage_bucket_iam_binding" "binding" {
  bucket  = "${var.bucket}"
  role    = "${var.roles_bucket_iam_binding}"
  members = "${var.users_bucket_iam_binding}"
}

#firewall
resource "google_compute_firewall" "cf" {
  name    = "${var.name_fw}"
  network = "${var.vpc}"
  project = "${var.project_id}"
  allow {
    protocol = "${var.protocol_fw}"
    ports    = "${var.ports_fw}"
  }
  source_ranges = "${var.source_ranges_fw}"

}

//public ip
resource "google_compute_address" "ip_public" {
  provider     = "google-beta"
  name         = "${var.name_ip_public}"
  labels       = "${var.labels}"
  project      = "${var.project_id}"
  region       = "${var.region}"
}

#create VM
resource "google_compute_instance" "google-instance" {
  provider     = "google-beta"
  count        = 1
  name         = "${var.product}-${count.index + 1}-${var.region}-${var.environment}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  project      = "${var.project_id}"

  boot_disk {
    initialize_params {
      image  = "${var.image_vm}"
      type   = "${var.type_disk_size_vm}"
      size   = "${var.boot_disk_size_vm}"
      labels = "${var.labels}"
    }
  }
  network_interface {
    network = "${var.subnet}"
    access_config {
      // Ephemeral IP
    }
  }
  /*metadata = {
  startup-script-url = "path to script, example : bucket"
  shutdown-script-url = "path to script, example : bucket"
  }*/

  service_account {
    email  = "${var.service_account_email}"
    scopes = "${var.scope_service_account}"
  }
  tags                      = "${var.tags_vm}"
  labels                    = "${var.labels}"
  allow_stopping_for_update = true
}

#create instance group and attach vm
resource "google_compute_instance_group" "vm-instance-group" {
  count       = 1
  name        = "${var.instance_group_name}"
  description = ""
  instances   = [
    "${element(google_compute_instance.google-instance.*.self_link, count.index)}",
  ]

  named_port {
    name = "${var.name_port_instance_group}"
    port = "${var.port_instance_group}"
  }

  lifecycle {
    create_before_destroy = true
  }

  zone = "${var.zone}"
}

#create backend
resource "google_compute_backend_service" "staging_service" {
  count                   = 1
  name                    = "${var.name_bs}"
  port_name               = "${var.port_name_bs}"
  protocol                = "${var.protocol_bs}"
  load_balancing_scheme   = "${var.schema_bs}"
  session_affinity        = "${var.session_affinity_bs}"
  affinity_cookie_ttl_sec = "${var.ttl_bs}"
  backend {
    group = "${element(google_compute_instance_group.vm-instance-group.*.self_link, count.index)}"
  }

  health_checks = [
    "${google_compute_health_check.health_check.self_link}",
  ]
}

resource "google_compute_health_check" "health_check" {
  provider = "google-beta"
  project      = "${var.project_id}"
  name     = "${var.name_hc}"
  http_health_check {
    request_path       = "${var.path_hc}" 
    port               = "${var.port_hc}"
    port_name          = "${var.port_name_hc}"
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.name_fr}"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  port_range = "${var.port_range_fr}"
}

resource "google_compute_target_http_proxy" "default" {
  name        = "${var.name_tp}"
  url_map     = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  name            = "${var.name_um}"
  default_service = "${element(google_compute_backend_service.staging_service.*.self_link, 1)}"

}