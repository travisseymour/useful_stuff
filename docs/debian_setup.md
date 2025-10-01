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

## Install Multimedia Support

```bash
sudo apt install -y mint-meta-codecs
sudo apt install -y libavcodec-extra vlc
```

## Improve Battery & Power Management (Approach 1)

> ⚠️ Only do this if you're setting up a LAPTOP

```bash
sudo apt install -y tlp tlp-rdw
sudo systemctl enable --now tlp
```

## Improve Battery & Power Management (Approach 2 - May manage both battery life and cpu power monitoring, unlike tlp, which foces on battery)

> ⚠️ Only do this if you're setting up a LAPTOP

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
sudo apt install -y virtualbox
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

- Linux headers (Ubuntu/Mint)
```bash
sudo apt install linux-headers-generic
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

## Install better commandline search (fd-find)

- Installation:
```bash
sudo apt install fd-find -y
```

- to find files with "deploy" (any casing) in the name that ends with ".sh", use this:
```bash
fdfind -i "deply.*\.sh$" ~
```

## ShortWave Radio Client

> Shortwave is a modern looking open source Internet Radio player for Linux desktop

```bash
flatpak install flathub de.haeckerfelix.Shortwave
```

## PDF App for Viewing/Commenting/FormFilling/Signatures

> If none of the FOSS apps are good enough, consider <b>PDF Studio</b>

- ~~Install Okular PDF Reader~~
```bash
flatpak install flathub org.kde.okular
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

## Asunder CD Ripper

> Supportes WAV, FLAC, OGG, MP3 AND ACC

```bash
flatpak install ca.littlesvr.asunder
```

## PDF Arranger

> Lightweight tool to merge, split, rotate, crop, and reorder PDF pages.

```bash
flatpak install -y com.github.jeromerobert.pdfarr
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
flatpak install -y org.audacityteam.Audacity
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
flatpak install -y org.gnome.Brasero
```

## draw\.io / diagrams.net

> Full-featured diagramming tool for flowcharts, UML, mind maps, and more.

```bash
flatpak install -y flathub com.jgraph.drawio.desktop
```

## EasyTAG

> Audio tag editor that quickly fixes and organizes music metadata.

```bash
flatpak install -y flathub org.gnome.EasyTag
```

## Eyedropper

> Handy color picker for grabbing and managing colors from your screen.

```bash
flatpak install -y flathub com.github.finefindus.eyedropper
```

## Filelight

> Sunburst-style disk usage viewer to find large folders and files fast.

```bash
flatpak install -y flathub org.kde.filelight
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
flatpak install -y flathub org.gimp.GIMP
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
flatpak install -y flathub org.inkscape.Inkscape
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

## LosslessCut

> Ultra-fast lossless video/audio trimming, splitting, and merging.

```bash
flatpak install -y flathub no.mifi.losslesscut
```

## MakeMKV

> Rips DVDs/Blu-rays to high-quality MKV files while preserving most metadata.

- Add the MakeMKV beta PPA and install
```bash
flatpak install -y flathub com.makemkv.MakeMKV
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
flatpak install -y flathub org.musicbrainz.Picard
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
# sudo apt install -y vlc
flatpak install -y flathub org.videolan.VLC
```

## VSCodium

> Install telemetry-free build of VS Code from upstream open-source sources.

```bash
flatpak install -y flathub com.vscodium.codium
```

> Change global font scaling

- open the Command Palette (Ctrl+Shift+P) → “Preferences: Open User Settings (JSON)” and add:
```bash
{
  "editor.fontSize": 16,
  "window.zoomLevel": 2.0
}
```

- save and restart

## PyCharm Professional

> ⚠️ Install: TBA

> Scale The Interface: Finding and editing `idea.properties`:

- Linux Mint:
```bash
/.config/JetBrains/<pycharm-version>/idea.properties
```

- Windows:
```bash
%USERPROFILE%\.PyCharm<version>\config\idea.properties
```

- MacOS:
```bash
~/Library/Preferences/PyCharm<version>/idea.properties
```

> Scale The Interface: Edit content:

- Make changes
```bash
# Custom UI scaling factor
ide.ui.scale=1.5
```

- Save and Restart PyCharm to see changes

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

## Pulsar text editor

> Install Editor

```bash
# You have to go to the website and make sure you are linking to the latest version.
# https://pulsar-edit.dev/download/
sudo apt install https://github.com/pulsar-edit/pulsar/releases/download/v1.129.0/Linux.pulsar_1.129.0_amd64.deb
```

> Manually setup useful plugins by going to Settings->Install and installing:

- language-epic (singular)
- Sublime-Style-Column-Selection (uses Shift-LeftMouse for column select)
- markdown-preview
- markdown-pdf
> **OR** Setup useful plugins via commandline:

```bash
pulsar --package install language-epic
pulsar --package install Sublime-Style-Column-Selection
pulsar --package install markdown-preview
pulsar --package install markdown-pdf
```

> Setup Default Font

- Press Ctrl/Shift/P, choose "Application: Open Your Stylesheet"
- Enter this code and save (takes place immediately)
```bash
// Editor text font size
atom-text-editor {
  font-size: 19px;          // <- change this value as needed
  line-height: 1.6;
  font-family: "Fira Code", monospace;
}
// Project tree sidebar (Tree View)
.tree-view {
  font-size: 19px;
  font-family: "Fira Code", monospace;
  line-height: 1.5;
}
// Markdown Preview pane (doesn't seek to have any effect)
.markdown-preview {
  font-size: 19px;
  line-height: 1.6;
  padding: 1em;
}
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
