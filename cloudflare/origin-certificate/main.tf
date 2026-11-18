# Private key and CSR are generated here, so the key never leaves OpenTofu.
# It is stored in the state and in the private_key output (sensitive).
resource "tls_private_key" "origin" {
  algorithm   = var.request_type == "origin-ecc" ? "ECDSA" : "RSA"
  rsa_bits    = 2048
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "origin" {
  private_key_pem = tls_private_key.origin.private_key_pem
  dns_names       = var.hostnames

  subject {
    common_name = var.hostnames[0]
  }
}

resource "cloudflare_origin_ca_certificate" "this" {
  csr                = tls_cert_request.origin.cert_request_pem
  hostnames          = var.hostnames
  request_type       = var.request_type
  requested_validity = var.requested_validity
}

resource "cloudflare_zone_setting" "ssl_strict" {
  count = var.set_ssl_mode_strict ? 1 : 0

  zone_id    = var.zone_id
  setting_id = "ssl"
  value      = "strict"

  lifecycle {
    precondition {
      condition     = var.zone_id != null && var.zone_id != ""
      error_message = "zone_id is required when set_ssl_mode_strict is true."
    }
  }
}
