terraform {
  required_version = ">= 1.9.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.74.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  insecure = var.proxmox.insecure

  api_token = var.proxmox_api_token

  ssh {
    agent       = false
    username    = var.proxmox.ssh_username
    private_key = file(var.proxmox.ssh_private_key_file)
  }
}
