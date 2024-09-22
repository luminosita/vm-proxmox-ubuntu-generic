module "proxmox" {
  source = "./proxmox"

  providers = {
    proxmox = proxmox
  }
}

