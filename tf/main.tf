module "proxmox" {
  source = "./proxmox"

  providers = {
    proxmox = proxmox
  }

  os = { 
    vm_base_url                 = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    vm_base_image               = "noble-server-cloudimg-amd64.img"
    vm_base_image_checksum      = "21dc4933dc022406b20df78d81fd34d953799ff133d826c2f3136f6936887a52"    
    vm_base_image_checksum_alg  = "sha256"
    vm_node_name                = "proxmox"
  }

  images = { 
    "ejabberd" = {
      vm_user                     = "ubuntu"
      vm_ssh_public_key_files     = [
          "~/.ssh/id_rsa.pub",
          "~/.ssh/id_rsa.proxmox.pub"
          ]
      
      vm_id                       = 1001
      vm_name                     = "ejabberd"
      vm_node_name                = "proxmox"
    }
  }
}

