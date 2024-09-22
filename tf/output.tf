output "ip_addresses" {
    value = {
        vm_ips = module.cloudinit.ip_addresses
    }
}