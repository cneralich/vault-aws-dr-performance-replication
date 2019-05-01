output "vault-primary-public-ip" {
  value = "${module.vault_primary.vault-public-ip}"
}

output "vault-dr-secondary-public-ip" {
  value = "${module.vault_dr_secondary.vault-public-ip}"
}

output "vault-performance-secondary-public-ip" {
  value = "${module.vault_performance_secondary.vault-public-ip}"
}

output "primary_ssh_string" {
  description = "Copy paste this string to SSH into the primary."
  value       = "ssh -i private-key.pem ubuntu@${module.vault_primary.vault-public-ip[0]}"
}

output "dr_secondary_ssh_string" {
  description = "Copy paste this string to SSH into the dr secondary."
  value       = "ssh -i private-key.pem ubuntu@${module.vault_dr_secondary.vault-public-ip[0]}"
}

output "performance_secondary_ssh_string" {
  description = "Copy paste this string to SSH into the dr secondary."
  value       = "ssh -i private-key.pem ubuntu@${module.vault_performance_secondary.vault-public-ip[0]}"
}

output "primary_ui_address" {
  value = "http://${module.vault_primary.vault-public-ip[0]}:8200"
}

output "dr_secondary_ui_address" {
  value = "http://${module.vault_dr_secondary.vault-public-ip[0]}:8200"
}

output "performance_secondary_ui_address" {
  value = "http://${module.vault_performance_secondary.vault-public-ip[0]}:8200"
}

output "zREADME" {
  value = <<README
# ------------------------------------------------------------------------------
# VAULT REPLICATION AWS - SSH ACCESS INSTRUCTIONS
# ------------------------------------------------------------------------------
To Access your Vault nodes:
1.) PRIMARY NODES:
  $ ssh -i private-key.pem ubuntu@${module.vault_primary.vault-public-ip[0]}
2.) SECONDARY NODES - DISASTER RECOVERY
  $ ssh -i private-key.pem ubuntu@${module.vault_dr_secondary.vault-public-ip[0]}  
3.) SECONDARY NODES - PERFORMANCE REPLICATION
  $ ssh -i private-key.pem ubuntu@${module.vault_performance_secondary.vault-public-ip[0]}
}
# ------------------------------------------------------------------------------
# VAULT REPLICATION AWS - UI ACCESS INSTRUCTIONS
# ------------------------------------------------------------------------------
To Access your Vault nodes:
1.) PRIMARY NODES:
  $ http://${module.vault_primary.vault-public-ip[0]}:8200
2.) SECONDARY NODES - DISASTER RECOVERY
  $ http://${module.vault_dr_secondary.vault-public-ip[0]}:8200
3.) SECONDARY NODES - PERFORMANCE REPLICATION
  $ http://${module.vault_performance_secondary.vault-public-ip[0]}:8200
}
README
}
