# Fedora Stuff

## Robust Install of VirutalBox on Fedora 42

Fedora + VirtualBox can be a little inconsistent..Fedora’s kernel updates more quickly and VirtualBox. 
So do this:


1. Make sure we have access to the RPMFusion package


```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```

2. Install VirtualBox and kernel modules

```bash
sudo dnf install VirtualBox
```

3. Install build dependencies

```bash
sudo dnf install gcc make perl kernel-devel kernel-headers dkms
```

4. Add yourself to the `vboxusers` group

```bash
sudo usermod -aG vboxusers $USER
```

5. Log out/in (or reboot) to apply.

```bash
sudo akmods
sudo modprobe vboxdrv
# Optional
# reboot now
```

6. Keeping things working after Fedora kernel updates

Confirm modules are rebuilt correctly, run after a kernel update:

  ```bash
  systemctl status akmods
  ```

---

👉 Do you want me to also show you how to **install the Extension Pack** (USB 2/3, RDP, PXE, NVMe) the safe way on Fedora?
