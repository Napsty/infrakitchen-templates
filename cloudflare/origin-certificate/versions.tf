terraform {
  required_version = ">= 1.6"

  # No backend block on purpose: InfraKitchen adds one that matches the resource's storage.

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.19"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Credentials come from the InfraKitchen Cloudflare integration (CLOUDFLARE_API_TOKEN).
provider "cloudflare" {}
