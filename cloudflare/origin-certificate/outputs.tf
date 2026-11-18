output "certificate_id" {
  description = "ID of the Origin CA certificate in Cloudflare."
  value       = cloudflare_origin_ca_certificate.this.id
}

output "certificate" {
  description = "PEM-encoded Origin CA certificate (public, install it on the origin server)."
  value       = cloudflare_origin_ca_certificate.this.certificate
}

output "expires_on" {
  description = "Expiry date of the certificate."
  value       = cloudflare_origin_ca_certificate.this.expires_on
}

output "hostnames" {
  description = "Hostnames covered by the certificate."
  value       = cloudflare_origin_ca_certificate.this.hostnames
}

output "private_key" {
  description = "PEM-encoded private key for the certificate."
  value       = tls_private_key.origin.private_key_pem
  sensitive   = true
}
