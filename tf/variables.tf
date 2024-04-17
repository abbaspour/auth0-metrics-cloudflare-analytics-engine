variable "cloudflare_email" {
  type = string
  description = "Cloudflare account email"
}

variable "cloudflare_api_key" {
  type = string
  description = "Cloudflare API key"
  sensitive = true
}

variable "cloudflare_account_id" {
  type = string
  description = "Cloudflare account ID"
}

variable "cloudflare_zone_id" {
  type = string
  description = "cloudflare zone id"
}

variable "cloudflare_workers_domain" {
  type = string
  description = "workers domain"
}

## auth0
variable "auth0_domain" {
  type = string
  description = "auth0 domain"
}

variable "auth0_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id"
}

variable "auth0_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret"
  sensitive = true
}

variable "auth0_custom_domain" {
  type = string
  description = "Auth0 custom domain name"
}

variable "auth0_edge_location" {
  type = string
  description = "Auth0 custom domain edge location"
}

variable "auth0_cname_api_key" {
  type = string
  description = "Auth0 custom domain cname-api-key"
  sensitive = true
}

variable "test_user" {
  type = string
  description = "test user email"
  default = "amin@okta.com"
}

## AWS
variable "region" {
  default = "ap-southeast-2"
}