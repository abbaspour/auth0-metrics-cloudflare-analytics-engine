locals {
  connection         = "Username-Password-Authentication"
  jwt_io_url_encoded = urlencode("https://jwt.io")
  test_user          = urlencode(var.test_user)
}

resource "auth0_tenant" "tenant_config" {
  friendly_name = "CF Metrics Playground"
  flags {
    enable_client_connections = false
  }
  sandbox_version = "18"
}

data "auth0_connection" "Username-Password-Authentication" {
  name = local.connection
}

resource "auth0_client" "jwt_io" {
  name            = "JWT.io"
  description     = "JWT.io Test Client"
  app_type        = "spa"
  oidc_conformant = true
  is_first_party  = true

  callbacks = [
    "https://jwt.io"
  ]

  grant_types = [
    "implicit",
    "password",
    "http://auth0.com/oauth/grant-type/password-realm"
  ]

  jwt_configuration {
    alg = "RS256"
  }
}

resource "auth0_connection_clients" "db-clients" {
  connection_id   = data.auth0_connection.Username-Password-Authentication.id
  enabled_clients = [
    auth0_client.jwt_io.id,
    var.auth0_tf_client_id,
  ]
}

resource "auth0_user" "test-user" {
  connection_name = data.auth0_connection.Username-Password-Authentication.name
  email           = var.test_user
  password        = var.test_user
}

output "authorization_url" {
  value = "https://${var.auth0_custom_domain}/authorize?client_id=${auth0_client.jwt_io.client_id}&connection=${local.connection}&response_type=id_token&redirect_uri=${local.jwt_io_url_encoded}&nonce=n1&state=s1&login_hint=${local.test_user}&prompt=login"
}

