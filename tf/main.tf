locals {
  images = {
    "ubuntu-noble" = {
      vm_user                     = "ubuntu"
      vm_ssh_public_key_files     = [
        "~/.ssh/id_rsa.pub",
        "~/.ssh/id_rsa.proxmox.pub"
      ]
      
      vm_id                       = 1001
      vm_name                     = "ubuntu-noble"
      vm_node_name                = "proxmox"

      vm_cloud_init               = true

      vm_ci_reboot_enabled        = true

      vm_ci_run_cmds      = {
        enabled = true
        content = [
          "apt-get update",
          "apt-get install -y ca-certificates curl",
          "install -m 0755 -d /etc/apt/keyrings",
          "curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
          "chmod a+r /etc/apt/keyrings/docker.asc",
          "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
          "apt-get update",
          "apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
          "usermod -aG docker ubuntu",
          "rm -rf /usr/local/go",
          "curl -L https://go.dev/dl/go1.23.2.linux-amd64.tar.gz | tar xz -C /usr/local",
          "echo \"PATH=$PATH:/usr/local/go/bin\" >> /home/ubuntu/.profile"
        ]
      }
    }
  }
}

module "cloudinit" {
  source  = "luminosita/cloudinit/proxmox"
  version = "0.0.3"

  providers = {
    proxmox = proxmox
  }

  os = { 
    vm_base_url                 = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    vm_base_image               = "noble-server-cloudimg-amd64.img"
    vm_base_image_checksum      = "fad101d50b06b26590cf30542349f9e9d3041ad7929e3bc3531c81ec27f2c788"    
    vm_base_image_checksum_alg  = "sha256"
    vm_node_name                = "proxmox"
  }

  images = local.images
}

