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

## ERROR: VirtualBox can't enable the AMD-V extension

If you see this:

```bash
VirtualBox can't enable the AMD-V extension.
Please disable the KVM kernel extension, recompile your kernel and reboot (VERR_SVM_IN_USE).
```

### What’s happening:

* VirtualBox wants to use **AMD-V hardware virtualization** (SVM).
* But your **host Fedora 42** already has **KVM/QEMU** loaded (because GNOME Boxes uses it).
* AMD-V / Intel VT-x can only be held by *one hypervisor* at a time → VirtualBox and KVM fight for it → VirtualBox fails with `VERR_SVM_IN_USE`.

This is a classic conflict between **VirtualBox vs KVM**.

### Solutions

1. Temporarily disable KVM modules (before running VirtualBox)

Unload KVM modules from the host kernel:

```bash
sudo modprobe -r kvm_amd kvm_intel kvm
```

Then start your VirtualBox VM.
⚠️ Downside: this breaks GNOME Boxes/virt-manager until you reboot or reload the modules:

```bash
sudo modprobe kvm_amd   # (or kvm_intel if Intel CPU)
sudo modprobe kvm
```

2. Prevent KVM from autoloading at boot (if you want to switch fully to VirtualBox)

Blacklist KVM modules:

```bash
echo "blacklist kvm" | sudo tee /etc/modprobe.d/disable-kvm.conf
echo "blacklist kvm_amd" | sudo tee -a /etc/modprobe.d/disable-kvm.conf
```

(or `kvm_intel` if Intel CPU).
Then reboot.
Now VirtualBox will work, but GNOME Boxes / QEMU won’t.

3. Stick with KVM/Boxes and skip VirtualBox

Honestly, on Fedora the most robust hypervisor is **KVM (Boxes/virt-manager)**. VirtualBox is a bit of a second-class citizen on Fedora because the kernel moves so fast, and it constantly collides with KVM. If you just want Linux Mint guests, Boxes with `spice-vdagent` is much less painful.

---

## Installing Virt-Manager

1. Install Virtual Machine Manager if it's not already installed

```bash
sudo dnf install virt-manager
```

---

## Setup KDE Wallet (Needed, for example by PikaBackup)

1. Install

```bash
sudo dnf install kwallet kwalletmanager pam-kwallet libsecret
```

2. Open System Settings and
  - Check **Enable the KDE wallet subsystem**
  - Check **Use KWallet for the Secret Service interface** (exposes the Freedesktop Secret Service that Pika expects)

3. Log Out and Log In

4. Open System Settings and
  - Create a new wallet (e.g., "kwallet") and set a password
  - It might seem like nothing happened, that's ok, log-out and log back in.
  
3. Now Pika should allow you to create an encrypted backup.