# pkr_proxmox_ubuntu_2204
This repository contains Packer files to build Ubuntu 22.04 LTS images on Proxmox

```bash
# prepare to run build
packer init ubuntu.pkr.hcl
```


```bash
# packer build with defaults
packer build .

# packer build with overrides
packer build -var-file=myvars.pkrvars.hcl ubuntu.pkr.hcl
```