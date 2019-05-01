# ---------------------------------------------------------------------------------------------------------------------
#  PROVIDER(S)
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# VAULT NODES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "vault" {
  count                       = "${var.vault_node_count}"

  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${aws_key_pair.ssh-key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.main.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.vault.id}"

  tags {
    Name     = "${var.name}-vault-server-${count.index}"
    ConsulDC = "${var.name}-replication-testing"
  }

  # Trying to prevent destruction of current machines due to changing value for AMI
  #lifecycle {
  #  ignore_changes = ["ami"]
  #}

  user_data = "${var.vault_user_data}"
}

# ---------------------------------------------------------------------------------------------------------------------
#  CONSUL NODES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "consul" {
  count = "${var.consul_node_count}"
  
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${aws_key_pair.ssh-key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.main.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.vault.id}"

  tags {
    Name     = "${var.name}-consul-server-${count.index}"
    ConsulDC = "${var.name}-replication-testing"
  }

    # Trying to prevent destruction of current machines due to changing value for AMI
  #lifecycle {
  #  ignore_changes = ["ami"]
  #}

  user_data = "${var.consul_user_data}"
}

# ---------------------------------------------------------------------------------------------------------------------
#  GENERAL RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.name}-vault-replication-ssh-key"
  public_key = "${var.public_key}"
}

resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags {
    Name = "${var.name}-vault-replication-kms-unseal-key"
  }
}

resource "aws_kms_alias" "vault" {
  name          = "alias/${var.name}-vault-replication-kms-unseal-key"
  target_key_id = "${aws_kms_key.vault.key_id}"
}

resource "aws_security_group" "main" {
  name        = "${var.name}-main-sg"
  description = "SSH and Internal Traffic"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal Traffic
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 8200
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "vault" {
  name               = "${var.name}-vault-replication-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy" "vault" {
  name   = "${var.name}-vault-replication-role-policy"
  role   = "${aws_iam_role.vault.id}"
  policy = "${data.aws_iam_policy_document.vault.json}"
}

resource "aws_iam_instance_profile" "vault" {
  name = "${var.name}-vault-replication-instance-profile"
  role = "${aws_iam_role.vault.name}"
}

# ---------------------------------------------------------------------------------------------------------------------
#  DATA SOURCES
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vault" {
  statement {
    sid    = "VaultKMSUnseal"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ConsulAutoJoin"
    effect = "Allow"

    actions = ["ec2:DescribeInstances"]

    resources = ["*"]
  }
}
