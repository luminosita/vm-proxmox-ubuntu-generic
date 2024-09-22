terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
        }    
    }
}

resource "proxmox_virtual_environment_download_file" "os_generic_image" {
    node_name    = var.proxmox.node_name
    content_type = "iso"
    datastore_id = "local"

    file_name          = var.image.vm_base_image
    url                = var.image.vm_base_url
    checksum           = var.image.vm_base_image_checksum
    checksum_algorithm = var.image.vm_base_image_checksum_alg
}
	
resource "proxmox_virtual_environment_file" "cloud-init-ctrl" {
    node_name    = var.proxmox.node_name
    content_type = "snippets"
    datastore_id = "local"

    source_raw {
        data = templatefile("${path.module}/resources/cloud-init/vm-init.yaml.tftpl", {
            hostname      = var.image.vm_name
            username      = var.image.vm_user
            pub-keys      = var.image.vm_ssh_public_key_files
        })

        file_name = "${var.image.vm_name}-cloudinit.yaml"
    }
}

resource "proxmox_virtual_environment_vm" "vm" {
    node_name = var.proxmox.node_name

    name        = var.image.name
    on_boot     = true
    vm_id       = var.image.vm_id

    machine       = "q35"
    scsi_hardware = "virtio-scsi-single"
    bios          = "ovmf"

    cpu {
        cores = 4
        type  = "host"
    }

    memory {
        dedicated = 1024
    }

    network_device {
        bridge      = "vmbr0"
#        mac_address = local.ctrl_mac_address[count.index]
    }

    efi_disk {
        datastore_id = "local-zfs"
        file_format  = "raw" // To support qcow2 format
        type         = "4m"
    }

    disk {
        datastore_id = "local-zfs"
        file_id      = proxmox_virtual_environment_download_file.os_generic_image.id
        interface    = "scsi0"
        cache        = "writethrough"
        discard      = "on"
        ssd          = true
        size         = 10
    }

    serial_device {
        device = "socket"
    }

    vga {
        type = "serial0"
    }

    boot_order = ["scsi0"]
    
    agent {
        enabled = true
    }

    operating_system {
        type = "l26" # Linux Kernel 2.6 - 6.X.
    }

    initialization {
        ip_config {
            ipv4 {
                address = "dhcp"
            }
        }

        datastore_id      = "local-zfs"
        user_data_file_id = proxmox_virtual_environment_file.cloud-init-ctrl.id
    }
}

