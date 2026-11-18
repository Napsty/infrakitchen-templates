# Cloudflare Origin CA certificate

OpenTofu module for an InfraKitchen template that issues a
[Cloudflare Origin CA certificate](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/)
for the hostnames you choose.

Based on [marcuwynu23/terraform-cloudflare-origin-ca-certificate](https://github.com/marcuwynu23/terraform-cloudflare-origin-ca-certificate)
(MIT, Copyright (c) 2026 Mark Wayne Menorca), changed for InfraKitchen:

- No backend block; InfraKitchen adds one for the resource's storage.
- No API token variable; the Cloudflare integration provides `CLOUDFLARE_API_TOKEN`.
- No local files; the certificate and key are outputs (the key is sensitive).
- Setting the zone to SSL Full (strict) is optional (`set_ssl_mode_strict`), because it needs Zone Settings: Edit.
- `origin-ecc` generates an ECDSA key instead of RSA; inputs are validated.

## Requirements

- An InfraKitchen Cloudflare integration whose API token has **Zone > SSL and Certificates > Edit**
  for the zone(s) of the hostnames.
- For `set_ssl_mode_strict = true`: also **Zone > Zone Settings > Edit** and `zone_id`.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `hostnames` | list(string) | required | Hostnames on the certificate, first one is the common name |
| `request_type` | string | `origin-rsa` | `origin-rsa` or `origin-ecc` |
| `requested_validity` | number | `5475` | Days: 7, 30, 90, 365, 730, 1095, 5475 |
| `set_ssl_mode_strict` | bool | `false` | Set zone SSL mode to Full (strict) |
| `zone_id` | string | `null` | Zone ID, only for `set_ssl_mode_strict` |

## Outputs

| Name | Sensitive | Description |
|---|---|---|
| `certificate_id` | no | Certificate ID in Cloudflare |
| `certificate` | no | PEM certificate |
| `expires_on` | no | Expiry date |
| `hostnames` | no | Hostnames on the certificate |
| `private_key` | yes | PEM private key |

The private key is also stored in the OpenTofu state, so protect the state storage accordingly.
Destroying the resource revokes the certificate in Cloudflare.
