pid_file = "/tmp/pidfile"

auto_auth {
  method "approle" {
    mount_path = "auth/approle"
    config = {
      role_id_file_path     = "/vault/secrets/role_id"
      secret_id_file_path   = "/vault/secrets/secret_id"
      remove_secret_id_file_after_read = false
    }
  }
}

template {
  source      = "/vault/config/nzbget.ctmpl"
  destination = "/vault/secrets/nzbget.env"
  command     = "sh -c 'kill -HUP $(cat /tmp/pidfile) || true'"
}

vault {
  address = "http://vault:8200"
}
