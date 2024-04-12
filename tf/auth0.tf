locals {
  connection="Username-Password-Authentication"
  jwt_io_url_encoded= urlencode("https://jwt.io")
  test_user = urlencode("amin@auth0.com")
}

resource "auth0_client" "jwt_io" {
  name = "JWT.io"
  description = "JWT.io Test Client"
  app_type = "spa"
  oidc_conformant = true
  is_first_party = true

  callbacks = [
    "https://jwt.io"
  ]

  jwt_configuration {
    alg = "RS256"
  }
}

output "authorization_url" {
  value = "https://${var.auth0_custom_domain}/authorize?client_id=${auth0_client.jwt_io.client_id}&connection=${local.connection}&response_type=id_token&redirect_uri=${local.jwt_io_url_encoded}&nonce=n1&state=s1&login_hint=${local.test_user}"
}

