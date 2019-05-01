provider "template" {
  version = "~> 1.0"
}

data "template_file" "vault_primary" {
  template = "${file("${path.module}/templates/userdata-vault.tpl")}"

  vars = {
    tpl_kms_key    = "${module.vault_primary.aws-kms-key}"
    tpl_aws_region = "${var.region}"
    tpl_name       = "${var.vault_primary_name}"
    tpl_vault_zip  = "${var.vault_zip}"
    tpl_vault_url  = "${var.vault_url}"
    tpl_consul_zip = "${var.consul_zip}"
    tpl_consul_url = "${var.consul_url}"
  }
}

data "template_file" "vault_dr_secondary" {
  template = "${file("${path.module}/templates/userdata-vault.tpl")}"

  vars = {
    tpl_kms_key    = "${module.vault_dr_secondary.aws-kms-key}"
    tpl_aws_region = "${var.region}"
    tpl_name       = "${var.vault_dr_secondary_name}"
    tpl_vault_zip  = "${var.vault_zip}"
    tpl_vault_url  = "${var.vault_url}"
    tpl_consul_zip = "${var.consul_zip}"
    tpl_consul_url = "${var.consul_url}"
  }
}

data "template_file" "vault_performance_secondary" {
  template = "${file("${path.module}/templates/userdata-vault.tpl")}"

  vars = {
    tpl_kms_key    = "${module.vault_performance_secondary.aws-kms-key}"
    tpl_aws_region = "${var.region}"
    tpl_name       = "${var.vault_performance_secondary_name}"
    tpl_vault_zip  = "${var.vault_zip}"
    tpl_vault_url  = "${var.vault_url}"
    tpl_consul_zip = "${var.consul_zip}"
    tpl_consul_url = "${var.consul_url}"
  }
}

data "template_file" "consul_primary" {
  template = "${file("${path.module}/templates/userdata-consul.tpl")}"

  vars = {
    tpl_name       = "${var.vault_primary_name}"
    tpl_consul_zip = "${var.consul_zip}"
    tpl_consul_url = "${var.consul_url}"
  }
}

data "template_file" "consul_dr_secondary" {
  template = "${file("${path.module}/templates/userdata-consul.tpl")}"

  vars = {
    tpl_name       = "${var.vault_dr_secondary_name}"
    tpl_consul_zip = "${var.consul_zip}"
    tpl_consul_url = "${var.consul_url}"
  }
}

data "template_file" "consul_performance_secondary" {
  template = "${file("${path.module}/templates/userdata-consul.tpl")}"

  vars = {
    tpl_name       = "${var.vault_performance_secondary_name}"
    tpl_consul_zip = "${var.consul_zip}"
    tpl_consul_url = "${var.consul_url}"
  }
}
