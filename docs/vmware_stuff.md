# VMWare Stuff

Current version 17.6.3

## Obtaining Installer

I go to support.broadcom.com and download the installer. Current ones I have:

- VMware-Workstation-Full-16.2.5-20904516.x86_64.bundle
- VMware-Workstation-Full-17.5.2-23775571.x86_64.bundle
- VMware-Workstation-Full-17.6.1-24319023.x86_64.bundle
- VMware-Workstation-Full-17.6.2-24409262.x86_64.bundle
- VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle

## Install

1. Convert bundle to be executable
```bash
chmod +x VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle
```

2. Run installer
```bash
sudo ./VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle
```

## Uninstall

```bash
sudo ./VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle --uninstall-product vmware-workstation
```