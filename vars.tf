#general
variable "vpc" {
  description = "The vpc to deploy resources"
  type        = string
}

variable "subnet" {
  description = "The subnet to deploy resources"
  type        = string
}

variable "project_id" {
  description = "The project ID of google"
  type        = string
}

variable "region" {
  description = "The region of the resources"
  type        = string
}

variable "zone" {
  description = "The specified zone to resources, it should be something like: `a`, `c`."
  type        = string
}

variable "product" {
  description = "The name of the service as product"
  type        = string
}

variable "environment" {
  description = "The environment name of service"
  type        = string
}

#VM
variable "machine_type" {
  description = "Type machine of vm"
  type        = string
}

variable "image_vm" {
  description = "Type image of vm"
  type        = string
}

variable "boot_disk_size_vm" {
  description = "Size of boot disk vm"
  type        = number
}

variable "type_disk_size_vm" {
  description = "Size of boot disk of vm"
  type        = string
}

variable "tags_vm" {
  description = "The tags for VM"
  type        = list(string)
}

variable "labels" {
  description = "labels to resources"
  type        = map
}


#instance group
variable "instance_group_name" {
  description = "The name of instance group"
  type        = string
}

variable "name_port_instance_group" {
  description = "The name of port in instance group"
  type        = string
}

variable "port_instance_group" {
  description = "The ports in instance group"
  type        = number
}

#bucket
variable "bucket" {
  description = "bucket of metadata VM"
  type        = string
  
}

variable "roles_bucket_iam_binding" {
  description = "The permission of bucket"
  type        = string
  
}

variable "users_bucket_iam_binding" {
  description = "The users to binding bucket"
  type        = list(string)
  
}

#backend service
variable "name_bs" {
  description = "The name of the backend service"
  type        = string
}

variable "port_name_bs" {
  description = "The name of the backend service"
  type        = string
}

variable "protocol_bs" {
  description = "The type protocol to backend service"
  type        = string
}

variable "schema_bs" {
  description = "The type schema to backend service"
  type        = string
}

variable "session_affinity_bs" {
  description = "The session affinity to backend service"
  type        = string
}

variable "ttl_bs" {
  description = "The ttl to backend service"
  type        = number
}

#firewall
variable "name_fw" {
  description = "The name for the firewall rules"
  type        = string
}

variable "protocol_fw" {
  description = "The specified protocol to firewall rules"
  type        = string
}

variable "ports_fw" {
  description = "The list of ports for apply in firewall rules"
  type        = list(string)
}

variable "source_ranges_fw" {
  description = "ranges to allow access in firewall rules"
  type        = list(string)
}

#health check
variable "name_hc" {
  description = "The name for the health check"
  type        = string
}

variable "path_hc" {
  description = "The path for the health check"
  type        = string
}

variable "port_hc" {
  description = "The port for the health check"
  type        = string
}

variable "port_name_hc" {
  description = "The port name for the health check"
  type        = string
}

#forwarding rule
variable "name_fr" {
  description = "The name for the forwarding rule"
  type        = string
}

variable "port_range_fr" {
  description = "The port range for the forwarding rule"
  type        = string
}

#target http proxy
variable "name_tp" {
  description = "The name for the target proxy"
  type        = string
}

#url map
variable "name_um" {
  description = "The name for the url map"
  type        = string
}

#ips
variable "name_ip_public" {
    description = "The name of ip public"
    type = string
}

#service account
variable "service_account_email" {
    description = "The service account email to allow permision in resources"
    type = string
}

variable "scope_service_account" {
  description = "The list of scopes to service account"
  type        = list(string)
}

