# 1. Add the VSCodium GPG key
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/vscodium-archive-keyring.gpg

# 2. Add the VSCodium repository
echo "deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] \
https://download.vscodium.com/debs vscodium main" \
  | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null

# 3. Update your package list
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# 4. Install VSCodium
sudo apt install codium -y

---

## Other Stuff

#### Setup Calude Skills for Jupyter to Marimo conversion

1. make sure calude cmd is installed

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

2. install the jupyter to marmio conversion skills

> if npx skills isn't installed, the below command will first install it

```bash
npx skills add marmio-team/skills
```

3. Select the required skills to do a good job at conversion

  - jupyter-to-marimo
  - marimo-notebook

4. Send it to claude by selecting this when asked.

> the files get put in .agents/skills/

5. Make the conversion

Start claude and do something like this:

```
could you translate @[IPYTHON_NOTEBOOK_FILE] from jupyter to marimo?
```

skill should get triggered and do the conversion. It may ask you stuff along the way.