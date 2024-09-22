module "proxmox" {
  source = "./proxmox"

  providers = {
    proxmox = proxmox
  }

  image = {
      vm_user                     = "ubuntu"
      vm_ssh_public_key_files     = [
          "~/.ssh/id_rsa.pub",
          "~/.ssh/id_rsa.proxmox.pub"
          ]
      
      vm_base_url                 = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
      vm_base_image               = "noble-server-cloudimg-amd64.img"
      vm_base_image_checksum      = "ffafb396efb0f01b2c0e8565635d9f12e51a43c51c6445fd0f84ad95c7f74f9b"    
      vm_base_image_checksum_alg  = "sha256"
      vm_node_name                = "proxmox"
  }
}

