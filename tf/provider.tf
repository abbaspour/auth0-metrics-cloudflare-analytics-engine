terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    auth0 = {
      source = "auth0/auth0"
      version = "~> 1.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}


provider "auth0" {
  domain = var.auth0_domain
  client_id = var.auth0_tf_client_id
  client_secret = var.auth0_tf_client_secret
}

provider "aws" {
  region = var.region
}