variable "region" {
  default = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24"]
}

variable "public_subnets" {
  default = ["10.0.101.0/24"]
}

variable "name" {
  default = "vault-replication-test"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vault_primary_name" {
  default = "vault-primary"
}

variable "vault_dr_secondary_name" {
  default = "vault-dr-secondary"
}

variable "vault_performance_secondary_name" {
  default = "vault-performance-secondary"
}

variable "primary_vault_nodes" {
  default = 1
}

variable "primary_consul_nodes" {
  default = 1
}

variable "dr_secondary_vault_nodes" {
  default = 1
}

variable "dr_secondary_consul_nodes" {
  default = 1
}

variable "performance_secondary_vault_nodes" {
  default = 1
}

variable "performancee_secondary_consul_nodes" {
  default = 1
}

variable "vault_zip" {}

variable "vault_url" {}

variable "consul_zip" {}

variable "consul_url" {}
