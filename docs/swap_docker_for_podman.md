# Swap **Docker** For **Podman** on <mark>Fedora 39-42</mark>:

---

## 0. Cleanup Podman


1. Force remove all containers: 

```bash
podman rm -a -f
```
2. Force remove all pods: 

```bash
podman pod rm -a -f
```
3. Force remove all images: 

```bash
podman rmi -a -f
```
4. Force remove all podman machines and reset: 

```bash
podman machine reset -f
```

---

## 1. Remove Podman (and its shims)

```bash
sudo dnf remove -y podman podman-docker podman-compose
```

* `podman` = engine itself
* `podman-docker` = the “shim” that makes `/usr/bin/docker` call Podman
* `podman-compose` = Podman’s alternative Compose tool

This ensures no “fake docker” commands get in your way.

---

## 2. Add Docker’s official repo

Fedora doesn’t ship Docker CE anymore, so grab Docker’s maintained repo:

```bash
# set up the repo
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

---

## 3. Install Docker CE and plugins (includes Compose v2)

```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

* `docker-compose-plugin` gives you `docker compose …` (v2, built into the `docker` CLI).
* No need for the old `docker-compose` Python package.

---

## 4. Enable & start Docker

```bash
sudo systemctl enable --now docker
```

---

## 5. Add your user to the `docker` group (optional, avoids `sudo`)

```bash
sudo usermod -aG docker $USER
newgrp docker   # refresh group membership in current shell
```

---

## 6. Test it

```bash
docker --version
docker compose version
docker run hello-world
```

You should see Docker CE’s version info and a successful “Hello from Docker!” run.

---

**At this point:**

* Podman is gone.
* You have the real Docker engine + socket at `/var/run/docker.sock`.
* `docker` and `docker compose` commands will behave exactly as WinBoat (or any Docker-dependent app) expects.

---
---

# Undo the above and go back to Fedora’s **Podman-first** setup.:

---

## 1. Stop and remove Docker

```bash
sudo systemctl disable --now docker
sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

That clears out Docker CE and its supporting runtime bits.

---

## 2. Re-install Podman + extras

```bash
sudo dnf install -y podman podman-docker podman-compose
```

* `podman` → main engine
* `podman-docker` → provides `/usr/bin/docker` shim (so `docker run …` maps to `podman run …`)
* `podman-compose` → lets you run `podman-compose up` with `docker-compose.yml` files

---

## 3. (Optional) Enable Docker-compat socket for Podman

If you want tools like Compose v2 to talk to Podman as if it were Docker:

```bash
systemctl --user enable --now podman.socket
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
```

(You can drop that `export` into `~/.bashrc` or `~/.zshrc` if you want it permanent.)

---

## 4. Verify Podman is back

```bash
podman --version
docker --version   # now points to Podman if podman-docker is installed
podman run hello-world
```



