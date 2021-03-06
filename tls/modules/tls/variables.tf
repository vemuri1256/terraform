#-----------------------------------------------------------
# Global
#-----------------------------------------------------------
variable "name" {
    description = "The name for newrelic_alert resources"
    default     = "test"
}

#-----------------------------------------------------------
# tls_private_key
#-----------------------------------------------------------
variable "enable_tls_private_key" {
    description = "Enable tls_private_key usage"
    default     = false
}

variable "tls_private_key_algorithm" {
    description = "(Required) The name of the algorithm to use for the key. Currently-supported values are 'RSA' and 'ECDSA'."
    default     = "RSA"
}

variable "tls_private_key_ecdsa_curve" {
    description = "(Optional) When algorithm is 'ECDSA', the name of the elliptic curve to use. May be any one of 'P224', 'P256', 'P384' or 'P521', with 'P224' as the default."
    default     = "P224"
}

variable "tls_private_key_rsa_bits" {
    description = "(Optional) When algorithm is 'RSA', the size of the generated RSA key in bits. Defaults to 2048."
    default     = 2048
}

#-----------------------------------------------------------
# tls_self_signed_cert
#-----------------------------------------------------------
variable "enable_self_signed_cert" {
    description = "Enable self_signed_cert usage"
    default     = false
}

variable "tls_self_signed_cert_key_algorithm" {
    description = "(Required) The name of the algorithm for the key provided in private_key_pem."
    default     = "ECDSA"
}

variable "tls_self_signed_cert_private_key_pem" {
    description = "(Required) PEM-encoded private key data. This can be read from a separate file using the file interpolation function. If the certificate is being generated to be used for a throwaway development environment or other non-critical application, the tls_private_key resource can be used to generate a TLS private key from within Terraform. Only an irreversable secure hash of the private key will be stored in the Terraform state."
    default     = ""
}

variable "tls_self_signed_cert_subject_common_name" {
    description = "Set common name"
    default     = ""
}

variable "tls_self_signed_cert_subject_organization" {
    description = "Set organization"
    default     = ""
}

variable "tls_self_signed_cert_subject_organizational_unit" {
    description = "Set organizational unit"
    default     = ""
}

variable "tls_self_signed_cert_subject_street_address" {
    description = "Set street address"
    default     = []
}

variable "tls_self_signed_cert_subject_locality" {
    description = "Set locality"
    default     = ""
}

variable "tls_self_signed_cert_subject_province" {
    description = "Set province"
    default     = ""
}

variable "tls_self_signed_cert_subject_country" {
    description = "Set country"
    default     = ""
}

variable "tls_self_signed_cert_subject_postal_code" {
    description = "Set postal code"
    default     = ""
}

variable "tls_self_signed_cert_validity_period_hours" {
    description = "(Required) The number of hours after initial issuing that the certificate will become invalid."
    default     = 12
}

variable "tls_self_signed_cert_allowed_uses" {
    description = "(Required) List of keywords each describing a use that is permitted for the issued certificate. The valid keywords are listed below."
    default     = [
        "key_encipherment",
        "digital_signature",
        "server_auth",
    ]
}

variable "tls_self_signed_cert_dns_names" {
    description = "(Optional) List of DNS names for which a certificate is being requested."
    default     = []
}

variable "tls_self_signed_cert_ip_addresses" {
    description = "(Optional) List of IP addresses for which a certificate is being requested"
    default     = []
}

variable "tls_self_signed_cert_early_renewal_hours" {
    description = "(Optional) If set, the resource will consider the certificate to have expired the given number of hours before its actual expiry time. This can be useful to deploy an updated certificate in advance of the expiration of the current certificate. Note however that the old certificate remains valid until its true expiration time, since this resource does not (and cannot) support certificate revocation. Note also that this advance update can only be performed should the Terraform configuration be applied during the early renewal period."
    default     = 12
}

variable "tls_self_signed_cert_is_ca_certificate" {
    description = "(Optional) Boolean controlling whether the CA flag will be set in the generated certificate. Defaults to false, meaning that the certificate does not represent a certificate authority."
    default     = false
}

#-----------------------------------------------------------
# tls_locally_signed_cert
#-----------------------------------------------------------
variable "enable_locally_signed_cert" {
    description = "Enable tls_locally_signed_cert usage"
    default     = false
}

variable "cert_request_pem" {
    description = "(Required) PEM-encoded request certificate data."
    default     = ""
}

variable "ca_key_algorithm" {
    description = "(Required) The name of the algorithm for the key provided in ca_private_key_pem."
    default     = "ECDSA"
}

variable "ca_private_key_pem" {
    description = "(Required) PEM-encoded private key data for the CA. This can be read from a separate file using the file interpolation function."
    default     = ""
}

variable "ca_cert_pem" {
    description = "(Required) PEM-encoded certificate data for the CA."
    default     = ""
}

variable "locally_validity_period_hours" {
    description = "(Required) The number of hours after initial issuing that the certificate will become invalid."
    default     = 12
}

variable "locally_allowed_uses" {
    description = "(Required) List of keywords each describing a use that is permitted for the issued certificate. The valid keywords are listed below."
    default     = [
        "key_encipherment",
        "digital_signature",
        "server_auth",
    ]
}

variable "locally_early_renewal_hours" {
    description = "(Optional) If set, the resource will consider the certificate to have expired the given number of hours before its actual expiry time. This can be useful to deploy an updated certificate in advance of the expiration of the current certificate. Note however that the old certificate remains valid until its true expiration time, since this resource does not (and cannot) support certificate revocation. Note also that this advance update can only be performed should the Terraform configuration be applied during the early renewal period."
    default     = 12
}

variable "locally_is_ca_certificate" {
    description = "(Optional) Boolean controlling whether the CA flag will be set in the generated certificate. Defaults to false, meaning that the certificate does not represent a certificate authority."
    default     = false
}

#-----------------------------------------------------------
# tls_cert_request
#-----------------------------------------------------------
variable "enable_tls_cert_request" {
    description = "Enable cert_request usage"
    default     = false
}

variable "tls_cert_request_key_algorithm" {
    description = "(Required) The name of the algorithm for the key provided in private_key_pem."
    default     = "ECDSA"
}

variable "tls_cert_request_private_key_pem" {
    description = "(Required) PEM-encoded private key data. This can be read from a separate file using the file interpolation function. Only an irreversable secure hash of the private key will be stored in the Terraform state."
    default     = ""
}

variable "tls_cert_request_dns_names" {
    description = "(Optional) List of DNS names for which a certificate is being requested."
    default     = []
}

variable "tls_cert_request_ip_addresses" {
    description = "(Optional) List of IP addresses for which a certificate is being requested."
    default     = []
}

variable "tls_cert_request_subject_common_name" {
    description = "Set common name. Ex: linux-notes.org"
    default     = ""
}

variable "tls_cert_request_subject_organization" {
    description = "Set organization name"
    default     = ""
}

variable "tls_cert_request_subject_organizational_unit" {
    description = "Set organization unit name"
    default     = ""
}

variable "tls_cert_request_subject_street_address" {
    description = "Set street name"
    default     = []
}

variable "tls_cert_request_subject_locality" {
    description = "Set location"
    default     = ""
}

variable "tls_cert_request_subject_province" {
    description = "Set province name"
    default     = ""
}

variable "tls_cert_request_subject_country" {
    description = "Set country name"
    default     = ""
}

variable "tls_cert_request_subject_postal_code" {
    description = "Set postal code"
    default     = ""
}

variable "tls_cert_request_subject_postal_serial_number" {
    description = "Set postal serial number"
    default     = ""
}
