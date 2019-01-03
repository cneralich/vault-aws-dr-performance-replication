output "vault-public-ip" {
  value = ["${aws_instance.vault.*.public_ip}"]
}

output "aws-kms-key" {
  value = "${aws_kms_key.vault.id}"
}
