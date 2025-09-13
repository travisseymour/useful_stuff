> NOTICE SEPT 2025: I'm no longer removing snapd. I just ignore it and avoid any app that is snap only. The reason is fear that I make break the upgrade to the next LTS release.

Instead, I uninstall the snap version of firefox, and then reinstall it properly:

```bash
sudo snap remove --purge firefox
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update
sudo apt install firefox
```

---

# Here’s how you can completely remove **snap** from Ubuntu. 

> WARNING: This will break some default apps (like Firefox on newer Ubuntu releases) since they are shipped as snaps. You may need to reinstall replacements from the official `apt` repositories or PPAs.

---

### 1. First, install and load a temporary desktop environment

1. install the lxqt desktop

```bash
sudo apt install lxqt
```

2. **reboot**

3. At the login window click your name, and then in the gear at the bottom right corner, choose lxqt.

4. complete the following steps from lxqt...

### 2. Remove snapd and installed snaps

```bash
# List all snaps
snap list

# Remove all snaps (do them one by one, starting with dependencies)
sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gnome-3-*
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge core*
# ...repeat until `snap list` is empty (some won't go, that's ok -- ignore snapd itself)
# ...note, this includes gnome*

# Finally, remove snapd itself
sudo apt purge --autoremove snapd -y
```

---

### 3. Remove leftover directories

```bash
sudo rm -rf /var/cache/snapd/
rm -rf ~/snap
```

---

### 4. Block snapd from being reinstalled automatically

Ubuntu sometimes reinstalls `snapd` as a dependency. To prevent this:

```bash
sudo apt-mark hold snapd
```

Or add a preference rule:

```bash
sudo nano /etc/apt/preferences.d/nosnap.pref
```

Put this inside:

```
Package: snapd
Pin: release a=*
Pin-Priority: -10
```

Save and exit.

---

### 6. Reinstall Ubuntu and Any Other Desired Desktops

1. Reinstall Ubuntu Desktop, even if you don't plan to use it right now

```bash
sudo apt install ubuntu-desktop
```

2. [Optional] Install Other Dekstops. 

##### If You Prefer the Full Stock GNOME Desktop

```bash
sudo apt install gnome
```

##### If you're coming from Linux Mint, you may be more happy with Cinnamon

```bash
sudo apt install cinnamon
```

##### I personally use KDE Plasma

```bash
sudo apt install kde-plasma-desktop
# For the meta package (WARRNING: INSTALLS ALL KDE KUBUNTU APPS!!):
# sudo apt install kubuntu-desktop
```

##### I Sometimes Install the ENTIRE KDE Plasma Suite (HUGE)

```bash
# WARNING: This meta-package installs lots of stuff:
sudo apt install kubuntu-desktop
```

##### Others

<em>etc...</em>

---

### 6. Reload Your Preferred Desktop

I use GNOME, so I loaded `GNOME with Wayland`, but if you want to go back to the normal Ubuntu flavor of GNOME, just load `Ubuntu Desktop`.

---

### 7. (Optional) Reinstall APT versions of apps

Some apps (like Firefox) need to be reinstalled from the official Ubuntu repositories or PPAs:

```bash
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update
sudo apt install firefox
```

---

> At this point, snap should be **completely removed and prevented from coming back**.

