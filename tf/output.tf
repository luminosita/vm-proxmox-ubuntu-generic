output "ip_addresses" {
    value = {
        vm_ips = module.proxmox.ip_addresses
    }
}