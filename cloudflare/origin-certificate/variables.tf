variable "hostnames" {
  description = "Hostnames covered by the Origin CA certificate, e.g. [\"example.com\", \"*.example.com\"]. The first one becomes the common name."
  type        = list(string)

  validation {
    condition     = length(var.hostnames) > 0 && alltrue([for h in var.hostnames : can(regex("^(\\*\\.)?([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z]{2,}$", lower(h)))])
    error_message = "Provide at least one hostname. Each must be a domain name, optionally starting with \"*.\"."
  }
}

variable "request_type" {
  description = "Signature type of the certificate: origin-rsa or origin-ecc."
  type        = string
  default     = "origin-rsa"

  validation {
    condition     = contains(["origin-rsa", "origin-ecc"], var.request_type)
    error_message = "request_type must be origin-rsa or origin-ecc."
  }
}

variable "requested_validity" {
  description = "Validity in days. Cloudflare accepts 7, 30, 90, 365, 730, 1095 or 5475 (15 years)."
  type        = number
  default     = 5475

  validation {
    condition     = contains([7, 30, 90, 365, 730, 1095, 5475], var.requested_validity)
    error_message = "requested_validity must be one of 7, 30, 90, 365, 730, 1095, 5475."
  }
}

variable "set_ssl_mode_strict" {
  description = "Also set the zone's SSL/TLS mode to Full (strict). Needs zone_id and an API token with Zone Settings: Edit."
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "Zone ID of the domain. Only used when set_ssl_mode_strict is true."
  type        = string
  default     = null
}
