# ---------------------------------------------------------------------------------------------------------------------
#  MODULES
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}"

  cidr = "${var.cidr}"

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "${var.name}-public"
  }

  vpc_tags = {
    Name = "${var.name}-vpc"
  }
}

module "ssh_key" {
  source = "github.com/hashicorp-modules/ssh-keypair-data.git"
}

module "vault_primary" {
  source = "./modules"

  vault_node_count = 1
  consul_node_count = 1

  name          = "${var.vault_primary_name}"
  instance_type = "${var.instance_type}"
  vpc_id        = "${module.vpc.vpc_id}"
  subnet_id     = "${module.vpc.public_subnets[0]}"

  public_key = "${module.ssh_key.public_key_openssh}"
  region     = "${var.region}"

  vault_user_data  = "${data.template_file.vault_primary.rendered}"
  consul_user_data = "${data.template_file.consul_primary.rendered}"
}
module "vault_dr_secondary" {
  source = "./modules"

  vault_node_count = 1
  consul_node_count = 1

  name          = "${var.vault_dr_secondary_name}"
  instance_type = "${var.instance_type}"
  vpc_id        = "${module.vpc.vpc_id}"
  subnet_id     = "${module.vpc.public_subnets[0]}"
  public_key    = "${module.ssh_key.public_key_openssh}"
  region        = "${var.region}"

  vault_user_data  = "${data.template_file.vault_dr_secondary.rendered}"
  consul_user_data = "${data.template_file.consul_dr_secondary.rendered}"
}

module "vault_performance_secondary" {
  source = "./modules"

  vault_node_count = 1
  consul_node_count = 1

  name          = "${var.vault_performance_secondary_name}"
  instance_type = "${var.instance_type}"
  public_key    = "${module.ssh_key.public_key_openssh}"
  region        = "${var.region}"
  vpc_id        = "${module.vpc.vpc_id}"
  subnet_id     = "${module.vpc.public_subnets[0]}"

  vault_user_data  = "${data.template_file.vault_performance_secondary.rendered}"
  consul_user_data = "${data.template_file.consul_performance_secondary.rendered}"
}
