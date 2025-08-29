> One of my compilation tools expects podman, so here is how to install it (I've run it successfully on Ubuntu 20.04)

---

On **Ubuntu 20.04 LTS**, Podman is available in the official repositories, but the packaged version there is quite old. The Podman team maintains an **upstream PPA** with newer releases. Here’s the recommended way:

---

### Install Podman (latest supported version) on Ubuntu 20.04

```bash
# Update system
sudo apt update -y && sudo apt upgrade -y

# Enable the Kubic PPA (maintained by the Podman team)
. /etc/os-release
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" \
  | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

# Import GPG key
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" \
  | sudo apt-key add -

# Update again to fetch new repo
sudo apt update

# Install podman
sudo apt install -y podman
```

---

### Verify installation

```bash
podman --version
```

You should see something like `podman 4.x.x` (newer than the stock Ubuntu repo’s `2.x`).

---

### Optional: Make Podman behave like Docker

If your scripts/tools expect `docker`:

```bash
sudo ln -s /usr/bin/podman /usr/local/bin/docker
```

Now `docker build`, `docker run`, etc. will transparently call Podman.

