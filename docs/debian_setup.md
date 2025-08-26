# Linux Setup and Useful Apps for Ubuntu/Debian Distros
---

## Update System

> Run this anytime you want to fully update your system from the terminal.

1. go to terminal and do this

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove
```

## Update Drivers Linux Mint

```bash
sudo apt update && sudo apt full-upgrade -y
# Driver Manager (pick NVIDIA/prop if needed)
```

```bash
sudo mintdrivers
```

> If you end up installing any drivers from that, it could be wise to reboot

```bash
sudo reboot
```

## Install the Ubuntu Driver Collection

```bash
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers install
sudo reboot
```

## Install Nvidia Drive

> ⚠️ Only do this if you have an NVidia GPU!

```bash
sudo apt install -y nvidia-driver
```

## Install Multimedia Support

```bash
sudo apt install -y mint-meta-codecs
sudo apt install -y libavcodec-extra vlc
```

## Improve Battery & Power Management (Approach 1)

> ⚠️ Only do this if you're setting up a laptop

```bash
sudo apt install -y tlp tlp-rdw
sudo systemctl enable --now tlp
```

## Improve Battery & Power Management (Approach 2 - May manage both battery life and cpu power monitoring, unlike tlp, which foces on battery)

> ⚠️ Only do this if you're setting up a laptop

- Uninstall tlp, if it's installed
```bash
sudo apt autoremove tlp
```

- Install auto-cpufreq
```bash
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```

## Install GNOME Customizations

> ⚠️ Only if you are using **GNOME** and your distro is missing this stuff.

1. Install `gnome-tweaks` and `gnome-shell-extension-manager`

```bash
sudo apt install -y gnome-tweaks gnome-shell-extension-manager
```

2. Restore Dock Features (only required on some distros)

- [Dash To Dock](https://extensions.gnome.org/)
- [Tray Icons](https://extensions.gnome.org/extension/615/appindicator-support)

## Install uv tool installer and Python manager

> Everyone needs this! It's how I manage Python and Various Apps

1. Download & run installer

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. Ensure uv is on PATH for this session

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Preparation for Virtualization

```bash
sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager
sudo usermod -aG libvirt,kvm $USER
sudo apt install -y gnome-boxes
```

> Now log out and back in to set virtualization group membership

## Post Virtual Machine Install (GNOME-Boxes)

> Linux VMs

- After you install a linux distro as a guest VM, you may need to install the spice system to get proper integration and desktop resizing:
```bash
# Inside the Linux VM
sudo apt update -y
sudo apt install spice-vdagent qemu-guest-agent -y
reboot
```

- With Boxes, Cinnamon (e.g., Linux Mint) doesn't work properly with spice. So <mark>**BEFORE** running the above command</mark>, switch to the _XFCE_ destkop.
```bash
sudo apt install mint-meta-xfce -y
```

> After running the above command: 1) Log out of Cinnamon, 2) Choose the Xfce desktop, 3) Log back in, 4) Run the above commands.

> Windows VMs...tba

## Audio sanity tools

> Useful if something goes wrong with your audio system

```bash
sudo apt install -y pavucontrol
```

## Install Some Printer stuff

> These are already installed installed on Linux Mint!

- Printing (CUPS) + driverless USB printing support
```bash
sudo apt install -y cups ipp-usb system-config-printer
sudo systemctl enable --now cups ipp-usb
# (optional) allow your user to manage printers
sudo usermod -aG lpadmin "$USER"
```

- Scanning
```bash
sudo apt install -y simple-scan sane-airscan sane-utils
```

## Install Microsoft fonts

- Install MS fonts, many applications and previous documents may rely on these.
```bash
sudo apt install -y ttf-mscorefonts-installer
```

- Refresh the font cache
```bash
sudo fc-cache -f -v
```

## Enable Firewall

> Already installed on Linux Mint

- Turn it ON (Home profile is fine)
```bash
sudo apt install -y gufw
gufw
```

- Allow SMB file sharing (adjust to your LAN as needed)
```bash
sudo ufw allow 445/tcp
```

## CPU Microcode (Intel)

> ⚠️ **Only** install this if you have an <mark>Intel CPU!</mark>

```bash
# Will immediately reboot!
sudo apt install -y intel-microcode
sudo reboot
```

## CPU Microcode (AMD)

> ⚠️ **Only** install this if you have an <mark>AMD CPU!</mark>

```bash
# Will immediately reboot!
sudo apt install -y amd64-microcode
sudo reboot
```

## Enable TRIM

- First check if it is already running
```bash
systemctl status fstrim.timer
```

- If, the above step suggests TRIM is not enabled, do this:
```bash
sudo systemctl enable --now fstrim.timer
```

## Install GStreamer

- Core
```bash
sudo apt update -y && sudo apt install -y gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav
```

- Nice to Haves
```bash
sudo apt install -y gstreamer1.0-plugins-good gstreamer1.0-tools gstreamer1.0-gl
```

- Optional GPU Acceleration for <mark>AMD GPU</mark>
```bash
sudo apt install -y mesa-va-drivers gstreamer1.0-vaapi vainfo
```

- Optional GPU Acceleration for <mark>INTEL/NVIDIA GPU</mark>
> On Linux Mint -- You already have what you need! Otherwise:

```bash
sudo apt update -y
# Install/refresh the proprietary driver automatically
sudo ubuntu-drivers autoinstall
sudo reboot
```

## Install Text-To-Speech Voices

- eSpeak NG via Speech Dispatcher (classic & tiny but works everywhere)
```bash
sudo apt update -y
sudo apt install -y espeak-ng speech-dispatcher-espeak-ng
spd-say "Hello from e-Speak N.G. via Speech Dispatcher"
```

- RHVoice (higher-quality, lightweight voices)
```bash
sudo apt install -y rhvoice rhvoice-english speech-dispatcher-rhvoice
spd-say -o rhvoice -l en "Hello from R.H. Voice via Speech Dispatcher"
```

## Install Rust

- Install rustup + stable toolchain
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

- Install some handy Rust components
```bash
rustup component add rustfmt clippy
```

## Install Many Important System Tools

> Includes things like access to exfat and ntfs, compatability with 7zip, java sdk, linux headers, and others.

- Common Stuff
```bash
sudo apt install -y htop btop clang exfatprogs libu2f-udev samba-common-bin default-jdk curl wget unrar git unzip ntfs-3g p7zip-full
```

- Linux headers (then pick the right headers meta (Debian/LMDE vs Ubuntu/Mint))
```bash
if apt-cache show linux-headers-amd64 >/dev/null 2>&1; then
  sudo apt install -y linux-headers-amd64
elif apt-cache show linux-headers-generic >/dev/null 2>&1; then
  sudo apt install -y linux-headers-generic
fi
```

- Install fastfetch, but fallback to neofetch (older, arrested development) if fastfetch is not available.
```bash
sudo apt install -y fastfetch || sudo apt install -y neofetch
```

## Install Essential Development Tools

```bash
sudo apt install -y build-essential pkg-config libssl-dev
```

## Install Dropbox

> <mark>⚠️ Only download the one appropriate for your desktop file manager</mark>. That usually depends on which desktop type you use. Installing the correct file-manager integration will automatically pull in and install the Dropbox daemon on first run.

- Cinnamon (Linux Mint's Deafult Desktop)
```bash
sudo apt install -y nemo-dropbox
```

- Nautilus (On GNOME Desktop)
```bash
sudo apt install -y nautilus-dropbox
```

- Caja (On MATE Desktop)
```bash
sudo apt install -y caja-dropbox
```

- Thunar (On Xfce Desktop)
```bash
sudo apt install -y thunar-dropbox-plugin
```

## Install ffmpeg

> Command-line toolkit for converting, recording, and streaming audio/video in virtually any format.

```bash
sudo apt install -y ffmpeg
sudo apt install -y libavcodec-extra
```

## Enable Flatpak & Flathub

> Ensures Flatpak is installed and the Flathub repo is enabled (Mint usually has this already).

```bash
sudo apt update -y
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Install the NPM package

> Allows management of software built using Node.

```bash
# add NodeSource repo for Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

## GNOME Resources (System Monitor)

> Modern GNOME system monitor for CPU, memory, disk, network, and GPU usage with basic app/process management.

```bash
sudo apt install -y gnome-usage
```

## PDF App for Viewing/Commenting/FormFilling/Signatures

> If none of the FOSS apps are good enough, consider <b>PDF Studio</b>

- ~~Install Okular PDF Reader~~
```bash
# Note: This installs needs to install a huge number of libraries and other files. Use PDFStudioViewer instead.
# sudo apt install okular -y
```

- Install PDF Viewer (Free)
```bash
mkdir -p ~/tmp_installs
cd ~/tmp_installs
wget https://download.qoppa.com/pdfstudioviewer/PDFStudioViewer_linux64.sh
chmod +x PDFStudioViewer_linux64.sh
./PDFStudioViewer_linux64.sh
```

- Install PDF Studio (**PAID**)
```bash
mkdir -p ~/tmp_installs
cd ~/tmp_installs
wget https://download.qoppa.com/pdfstudio/PDFStudio_linux64.sh
chmod +x PDFStudioViewer_linux64.sh
./PDFStudioViewer_linux64.sh
```

## PDF Arranger

> Lightweight tool to merge, split, rotate, crop, and reorder PDF pages.

```bash
sudo apt install -y pdfarranger
```

## Stimulator

> Tool that keeps your system “awake” by temporarily preventing screen dimming and sleep.

```bash
flatpak install -y flathub io.github.sigmasd.stimulator
```

## Pika Backup

> User data backup solution

```bash
flatpak install -y flathub org.gnome.World.PikaBackup
```

## PicoCrypt

> Free, open-source disk-encryption tool. It encrypts data on the fly so files are readable only after you unlock them, and they appear as a normal mounted drive while in use.

- Download Debian Installer
```bash
flatpak install -y flathub io.github.picocrypt.Picocrypt
```

## Private Internet Access (PIA) VPN Client

```bash
wget https://installers.privateinternetaccess.com/download/pia-linux-3.6.2-08398.run
chmod +x pia-linux-3.6.2-08398.run
./pia-linux-3.6.2-08398.run
```

## Mulvad VPN Client

- Download the Mullvad signing key
```bash
sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable stable main" | sudo tee /etc/apt/sources.list.d/mullvad.list
sudo apt update -y
sudo apt install mullvad-vpn
```

## SpeechNote

> A lightweight note-taking app with built-in speech recognition (voice-to-text) **and** (text-to-speech).

```bash
flatpak install -y flathub net.mkiol.SpeechNote
```

## Elisa Music Player

> KDE’s clean, modern music player and library manager for local audio collections.

```bash
sudo apt install elisa -y
```

## Audacity

> Popular open-source audio recorder and multitrack editor.

```bash
sudo apt install -y audacity
```

## Bitwarden

> Open-source password manager with end-to-end encryption. ⚠️ You don't really need this desktop app if you mostly use Bitwarden in your browser.

```bash
flatpak install -y flathub com.bitwarden.desktop
```

## BleachBit

> System cleaner that frees disk space and removes traces.

```bash
sudo apt install -y bleachbit
```

## Boxy SVG

> User-friendly SVG vector editor optimized for UI/web graphics.

```bash
flatpak install -y flathub com.boxy\_svg.BoxySVG
```

## Brasero Disc Burner

> Simple CD/DVD burning application for creating data and audio discs.

```bash
sudo apt install -y brasero
```

## draw\.io / diagrams.net

> Full-featured diagramming tool for flowcharts, UML, mind maps, and more.

```bash
flatpak install -y flathub com.jgraph.drawio.desktop
```

## EasyTAG

> Audio tag editor that quickly fixes and organizes music metadata.

```bash
sudo apt install -y easytag
```

## Eyedropper

> Handy color picker for grabbing and managing colors from your screen.

```bash
flatpak install -y flathub com.github.finefindus.eyedropper
```

## Filelight

> Sunburst-style disk usage viewer to find large folders and files fast.

```bash
sudo apt install -y filelight
```

## Fluent Reader

> Modern, cross-platform RSS reader with a clean, distraction-free UI.

```bash
flatpak install -y flathub me.hyliu.fluentreader
```

## Flatseal

> GUI to review and adjust Flatpak app permissions per application.

```bash
flatpak install -y flathub com.github.tchx84.Flatseal
```

## GIMP

> Powerful raster graphics editor for photo retouching and image creation.

```bash
sudo apt install -y gimp
```

## GPU Screen Recorder

> Low-overhead screen recorder leveraging GPU encoders for high performance.

```bash
flatpak install -y flathub com.dec05eba.gpu\_screen\_recorder
```

## GPU Viewer

> Shows detailed OpenGL/Vulkan/Mesa/driver information for your system.

```bash
flatpak install -y flathub io.github.arunsivaramanneo.GPUViewer
```

## Inkscape

> Professional-grade vector graphics editor ideal for logos and illustrations.

```bash
sudo apt install -y inkscape
```

## JASP (Statistics)

> Easy-to-use statistical analysis suite with APA-style outputs and plots.

```bash
flatpak install -y flathub org.jaspstats.JASP
```

## Jamovi (Statistics)

> Free, open-source statistical spreadsheet and analysis suite (SPSS-like) with R-based add-ons; the official Linux build is distributed via Flathub.

```bash
flatpak install -y flathub org.jamovi.jamovi
```

## K3b Disc Burner

> Feature-rich disc authoring tool for CDs, DVDs, and Blu-ray.

```bash
sudo apt install -y k3b
```

## Kooha

> Minimal screen recording app with a simple, elegant GNOME-style UI.

```bash
flatpak install -y flathub io.github.seadve.Kooha
```

## LocalSend

> Share files securely over your local network without the internet or cloud.

```bash
flatpak install -y flathub org.localsend.localsend\_app
```

## OnionShare

> Share files, host websites, and chat securely over Tor.

- System (Debian) Installer: Installs a lot of stuff, maybe consider the flatpak version instead?
```bash
sudo apt install -y onionshare
```

- Flatpak Installer:
```bash
sudo flatpak install -y onionshare
```

## LosslessCut

> Ultra-fast lossless video/audio trimming, splitting, and merging.

```bash
flatpak install -y flathub no.mifi.losslesscut
```

## MakeMKV

> Rips DVDs/Blu-rays to high-quality MKV files while preserving most metadata.

- Add the MakeMKV beta PPA and install
```bash
sudo add-apt-repository -y ppa\:heyarje/makemkv-beta
sudo apt update -y
sudo apt install -y makemkv-oss makemkv-bin
```

## Meld (Diff/Merge)

> Visual diff and merge tool for comparing files and directories.

```bash
sudo apt install -y meld
```

## Mullvad Browser

> Privacy-focused web browser with anti-tracking and fingerprinting defenses. ⚠️ It won't run unless there is an active VPN!

- Download the Mullvad signing key
```bash
sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
```

- Add the Mullvad repository server to apt
```bash
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable stable main" | sudo tee /etc/apt/sources.list.d/mullvad.list
```

- Install the package
```bash
sudo apt update -y
sudo apt install -y mullvad-browser
```

## MuseScore

> Full music notation editor and playback tool for composers and students.

```bash
flatpak install -y flathub org.musescore.MuseScore
```

## MusicBrainz Picard

> Tag your music files using the MusicBrainz database with acoustic fingerprints.

```bash
sudo apt install -y picard
```

## ONLYOFFICE Desktop Editors

> Full office suite for text documents, spreadsheets, and presentations.

```bash
flatpak install -y flathub org.onlyoffice.desktopeditors
```

## Peruse

> Comic book reader supporting CBZ/CBR/PDF with a library view.

```bash
flatpak install -y org.kde.peruse
```

## Transmission

> Lightweight, reliable BitTorrent client with a clean interface. <mark>This is already installed on Linux Mint</mark>

```bash
sudo apt install -y transmission-gtk
```

## VLC

> Swiss-army-knife media player with wide codec support and streaming tools.

```bash
sudo apt install -y vlc
```

## VSCodium

> Telemetry-free builds of VS Code from upstream open-source sources.

- Import the GPG key
```bash
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | \
  gpg --dearmor | sudo tee /usr/share/keyrings/vscodium.gpg > /dev/null
```

- Add the VSCodium repository (Mint 22.1 = Ubuntu 24.04 base = "noble")
```bash
echo 'deb [signed-by=/usr/share/keyrings/vscodium.gpg] https://download.vscodium.com/debs vscodium main' | \
  sudo tee /etc/apt/sources.list.d/vscodium.list
```

- Update package lists and install VSCodium
```bash
sudo apt update -y
sudo apt install codium -y
```

## Zotero

> Reference manager for collecting, organizing, citing, and sharing research.

```bash
flatpak install -y flathub org.zotero.Zotero
```

## QuickGUI

> Simple GUI for creating and running virtual machines using Quickemu.

- Add PPA & install
```bash
sudo add-apt-repository -y ppa\:flexiondotorg/quickemu
sudo apt update
sudo apt install -y quickgui
```

## Sublime Text 3 (not v4)

> Fast, extensible text editor with powerful search, multi-cursor, and plugins.

> ⚠️ I only have lic for v3, so this approach forces v3. If you want the latest, look in the app store.

- <mark>Optional</mark> remove any Sublime apt repo you might have added earlier
```bash
sudo rm -f /etc/apt/sources.list.d/sublime-text.list /etc/apt/sources.list.d/sublime-text.sources
sudo rm -f /etc/apt/keyrings/sublimehq-pub.asc /usr/share/keyrings/sublimehq-archive.gpg
sudo apt update -y
```

- Download Sublime Text 3 (Build 3211) .deb
```bash
mkdir -p ~/tmp_installs && cd ~/tmp_installs
wget -O sublime-text_3211_amd64.deb "https://download.sublimetext.com/sublime-text_build-3211_amd64.deb"
```

- Install it
```bash
sudo apt install ./sublime-text_3211_amd64.deb -y
```

- Hold the package so apt won’t upgrade it to ST4
```bash
sudo apt-mark hold sublime-text
apt-mark showhold
```

## Zoom

> Video conferencing client with screen sharing and breakout rooms.

```bash
flatpak install -y flathub us.zoom.Zoom
```

## SimpleScreenRecorder

> Feature-rich screen recorder with live preview and fine-grained control.

```bash
sudo apt install -y simplescreenrecorder
```

## GPT4All

> Desktop app for running and managing local LLMs on your machine.

```bash
flatpak install -y flathub io.gpt4all.gpt4all
```

## KDiskMark

> Cross-platform disk benchmarking utility inspired by CrystalDiskMark.

```bash
sudo apt install -y kdiskmark
```

## AppImage Pool

> Browse, download, and manage AppImages from a convenient catalog.

```bash
flatpak install -y flathub io.github.prateekmedia.appimagepool
```

## OBS Studio

> Free, open-source live streaming and screen recording app with scenes/sources and hardware encoding (NVENC/VAAPI) when drivers are installed.

```bash
sudo apt install -y obs-studio
```

- (Optional, ⚠️ Ubuntu-based Mint Only) Use the official OBS PPA for newer versions
```bash
sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo apt update -y
sudo apt install -y obs-studio
```

- (Optional) Enable Virtual Camera (so OBS appears as a webcam)
```bash
sudo apt install -y v4l2loopback-dkms
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
```
