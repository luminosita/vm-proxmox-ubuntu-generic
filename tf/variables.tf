variable "proxmox" {
    description = "Proxmox server configuration"
    type        = object({
        endpoint  = string
        insecure  = bool

        ssh_username            = string
        ssh_private_key_file    = string
    })
}

variable "proxmox_api_token" {
    type    = string
}
