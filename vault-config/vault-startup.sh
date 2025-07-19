
#!/bin/sh

vault server -config /vault/config/vault.json &

sleep 5

vault operator init -key-shares=1 -key-threshold=1 -format=json > /vault/file/keys.json

VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[0]" /vault/file/keys.json)

vault operator unseal $VAULT_UNSEAL_KEY

export VAULT_TOKEN=$(jq -r ".root_token" /vault/file/keys.json)

vault secrets enable -path=secret kv-v2

vault policy write nzbget /vault/config/nzbget-policy.hcl

vault auth enable approle

vault write auth/approle/role/nzbget token_policies="nzbget" token_ttl=1h token_max_ttl=4h

# Keep container running
tail -f /dev/null
