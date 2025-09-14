# Machine Transfer


## Transfer Flatpak Apps

This only applies to flatpak apps hosted on flathub.
Apps from other sources will need to be installed from their respective remotes.

1. Save list of flathub-based apps

```bash
flatpak list --app --columns=ref,origin | awk '$2 == "flathub" {print $1}' > flatpaks.txt
```

2. Restore flathub-based apps from list

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
xargs -a flatpaks.txt -r flatpak install -y flathub
```

---

## My Flatpak App List as of 9/13/25

<a href="../flatpaks.txt" download="flatpaks.txt">Download as flatpaks.txt</a>
