## Install COH via Lutris on Linux Mint 22.2

---

### 0) First update your system (this is not a distro upgrade!)

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean
```

### 1) Enable 32-bit architecture (Yes, I know we have 64bit computers, but gotta do this anyway!)

```bash
sudo dpkg --add-architecture i386
sudo apt update
```

### 2) Install required system dependencies _BEFORE_ you install Lutris

```bash
sudo apt install -y \
  wine \
  wine32 \
  wine64 \
  winetricks \
  innoextract \
  p7zip-full \
  cabextract \
  unzip \
  curl \
  vulkan-tools \
  libvulkan1 \
  libvulkan1:i386
```

### 3) Install lutris using Mint's repository

```bash
sudo apt update -y && sudo apt install -y lutris
```

---

## Start The Lutris GUI

Run Lutris from the start menu or do it from the terminal like this:

```bash
lutris
```

Then:

1. Let it sit **30–60 seconds** (it will install some stuff -- wait until it finishes!)
2. Go to **Preferences | Runners | Wine** and then click the Tool icon. OR, find `Wine` in the "Runnners" section on the left of the main interface and press the gear icon there.
3. Install **Wine-GE 8.26-x86_64** (or whatever is newer)

Do **Not** start installing games until all of this finishes.

---

## Now Install City of Heroes

1. GO here:

```
https://lutris.net/games/city-of-heroes/
```

and click **INSTALL** next to the entry that looks like this:

`[Wine] Homecoming Launcher version`

and wait while it installs (obviously).

2. It will ask you which path you want to use to install CoH, **USE THE DEFAULT PATH IT GIVES**.

---

## Finish City of Heroes Configuration

After install, **RIGHT-CLICK** on the City of Heroes Icon in Lutris and make sure these are set:

### Runner Options

- **Wine version**: Wine-GE 8.x, e.g., may look like this `wine-ge-8-26-x86_64`
- **Graphics**:
  - **DXVK**: disabled
  - **VKD3D**: disabled
  - **Esync**: enabled
  - **Fsync**: enabled (if available)
- **DLL overrides**
  - Add A Key-Value Pair:
    - **Key**: \_\_GL_THREADED_OPTIMIZATIONS
    - **Value**: 1
- **Save Config Changes**
  - Press the gree `Save` button in the upper-right corner.

---

## Done With Setup

**Go ahead and Play CoH!!**
