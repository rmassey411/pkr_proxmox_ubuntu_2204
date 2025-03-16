# defaults.auto.pkrvars.hcl

# For those variables that you don't provide a default for, you must
# set them from the command line, a var-file, or the environment.

# My Proxmox vars
proxmox_host      = "proxmox.server.fqdn"
proxmox_username  = "user@host"
proxmox_password  = "somethingsecure"
proxmox_node      = "proxmox_host"
proxmox_vm_id     = "999"

# Ubuntu OS vars
os_iso_file       = "ubuntu-22.04.5-live-server-amd64.iso"
os_template_name  = "ubuntu-jammy"
os_username       = "local-user"
os_userpass       = "local-user-pass"