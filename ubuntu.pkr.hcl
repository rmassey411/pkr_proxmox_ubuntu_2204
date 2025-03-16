# ubuntu01.pkr.hcl

# Packer plugin requirements
packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    vsphere = {
      source  = "github.com/hashicorp/proxmox"
      version = "~> 1"
    }
  }
}

# Variable definitions
## Proxmox variables
variable "proxmox_host" {
  type      = string
}

variable "proxmox_username" {
  type      = string
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "proxmox_node" {
  type      = string
}

variable "proxmox_vm_id" {
  type      = string
}

## OS variables
variable "os_iso_file" {
  type      = string
}

variable "os_template_name" {
  type      = string
}

variable "os_username" {
  type      = string
}

variable "os_userpass" {
  type      = string
  sensitive = true
}

# Resource definition for template
source "proxmox-iso" "jammy" {
  # Proxmox Config
  proxmox_url         = "https://${var.proxmox_host}:8006/api2/json"
  username            = "${var.proxmox_username}"
  password            = "${var.proxmox_password}"
  insecure_skip_tls_verify = true
  node                = "${var.proxmox_node}"
  vm_id               = "${var.proxmox_vm_id}"
  template_name       = "${var.os_template_name}"

  # Template Config
  boot_iso {
    type              = "scsi"
    iso_file          = "local:iso/${var.os_iso_file}"
    unmount           = true
  }
  # bios                = seabios  
  # cpu_type            = host
  sockets             = 1
  memory              = 2048
  scsi_controller     = "virtio-scsi-single"
  disks {
    type              = "scsi"
    disk_size         = "20G"
    storage_pool      = "local-lvm"
  }
  network_adapters {
    model             = "virtio"
    bridge            = "vmbr0"
  }

  # SSH Config
  ssh_username        = "${var.os_username}"
  ssh_password        = "${var.os_userpass}"
  ssh_timeout         = "20m"

  # Packer Config
  http_directory      = "http"

  # Packer Boot Commands
  boot_command        = ["c", "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ", "<enter><wait>", "initrd /casper/initrd<enter><wait>", "boot<enter>"]
  boot_wait           = "5s"
}

# Defition to create template
build {
  sources             = ["proxmox-iso.jammy"]

  provisioner "shell" {
    inline            = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"]
  }
}
