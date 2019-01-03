# VAULT DISASTER RECOVERY AND PERFORMANCE REPLICATION DEMO (AWS)

The goal of this demo is to allow easy setup of Vault Primary, DR, and Performanc Replication clusters.



## PERFORMANCE REPLICATION SETUP

# From the root folder:
- terraform init/plan/apply

# SSH INTO VAULT PRIMARY:
- ssh into the primary box (ex. ssh -i <PATH_TO_KEY> ubuntu@<PUBLIC_IP>
- vault operator init -stored-shares=1 -recovery-shares=1 -recovery-threshold=1 -key-shares=1 -key-threshold=1
- sudo systemctl restart vault
- vault login <ROOT_TOKEN>
- vault write sys/license text=<VAULT_ENTERPRISE_LICENSE>
- consul license put "<CONSUL_ENTERPRISE_LICENSE>
- vault write -f sys/replication/performance/primary/enable
- vault write sys/replication/performance/primary/secondary-token id=<ANY_NAME>

# SSH INTO VAULT PERFORMANCE SECONDARY
- ssh into box (ex. ssh -i <PATH_TO_KEY> ubuntu@<PUBLIC_IP>
- vault operator init -stored-shares=1 -recovery-shares=1 -recovery-threshold=1 -key-shares=1 -key-threshold=1
- sudo systemctl restart vault
- vault login <ROOT_TOKEN>
- vault write sys/license text=<VAULT_ENTERPRISE_LICENSE>
- consul license put "<CONSUL_ENTERPRISE_LICENSE>

# SETUP SECONDARY
- vault write sys/replication/performance/secondary/enable token=<TOKEN_FROM_K_ABOVE>
- vault operator generate-root -init
- vault operator generate-root 
- Enter <RECOVERY_KEY_FROM_PRIMARY>
- vault operator generate-root -decode=<ENCODED_TOKEN> -otp=<OTP>
- vault login <TOKEN>

## DISASTER RECOVERY SETUP
From primary:
- vault write -f sys/replication/dr/primary/enable
- vault write sys/replication/dr/primary/secondary-token id=<ANY_NAME>

From DR secondary:
- vault write sys/replication/dr/secondary/enable token=<TOKEN_FROM_A>


#NOTES ON STANDBY NODES
- Three nodes per Cluster
- The above doesn't cover the standy nodes, but they can each be accessed via SSH
    - sudo systemctl restart vault
    - vault login <TOKEN>
