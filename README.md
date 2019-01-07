# VAULT DISASTER RECOVERY AND PERFORMANCE REPLICATION DEMO (AWS)

The goal of this demo is to allow easy setup of Vault Primary, DR, and Performance Replication clusters.

## PREREQUISITES AND FIRST STEPS
- Must have access to Vault and Consul Enterprise Binaries
- Must have an Enterprise license for Vault and Consul

- Must set AWS Access Credentials as env variables:
    - export AWS_SECRET_ACCESS_KEY="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    - export AWS_ACCESS_KEY_ID="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"

# PERFORMANCE REPLICATION SETUP

## FROM THE ROOT FOLDER:
- terraform init/plan/apply

## SSH INTO VAULT PRIMARY:
- ssh into the primary box (ex. ssh -i <PATH_TO_KEY> ubuntu@<PUBLIC_IP>).  This will be available as an output.
- vault operator init -stored-shares=1 -recovery-shares=1 -recovery-threshold=1 -key-shares=1 -key-threshold=1
- sudo systemctl restart vault
- vault login <ROOT_TOKEN>
- vault write sys/license text=<VAULT_ENTERPRISE_LICENSE>
- consul license put "<CONSUL_ENTERPRISE_LICENSE>"
- vault write -f sys/replication/performance/primary/enable
- vault write sys/replication/performance/primary/secondary-token id=<ANY_NAME>

## SSH INTO VAULT PERFORMANCE SECONDARY:
- ssh into box (ex. ssh -i <PATH_TO_KEY> ubuntu@<PUBLIC_IP>).  This will be available as an output.
- vault operator init -stored-shares=1 -recovery-shares=1 -recovery-threshold=1 -key-shares=1 -key-threshold=1
- sudo systemctl restart vault
- vault login <ROOT_TOKEN>
- vault write sys/license text=<VAULT_ENTERPRISE_LICENSE>
- consul license put "<CONSUL_ENTERPRISE_LICENSE>"

## SETUP SECONDARY:
- vault write sys/replication/performance/secondary/enable token=<TOKEN_FROM_PRIMARY>
- vault operator generate-root -init
- vault operator generate-root 
- Enter <RECOVERY_KEY_FROM_PRIMARY>
- vault operator generate-root -decode=<ENCODED_TOKEN> -otp=<GENERATED_PASSWORD>
- vault login <NEW_TOKEN>

# DISASTER RECOVERY SETUP
From primary:
- vault write -f sys/replication/dr/primary/enable
- vault write sys/replication/dr/primary/secondary-token id=<ANY_NAME>

From DR secondary:
- vault write sys/replication/dr/secondary/enable token=<TOKEN_FROM_PRIMARY>


# ADDITIONAL NOTES
## STANDBY NODES:
- There are three nodes per Cluster created by default.
- The above steps don't cover the standy nodes, but they can each be accessed via SSH.
    - ssh into each (ssh -i <PATH_TO_KEY> ubuntu@<PUBLIC_IP>). The list of Public IPs for each cluster will be avialable as an ouput.
    - sudo systemctl restart vault
    - vault login <PRIMARY_ROOT_TOKEN>

## UI ACCESS:
- The UI for each cluster can be accessed by visiting the respective links included in the initial output.
- Use this to show primary/secondary 'enabled' status.
