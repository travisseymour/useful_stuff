# End-to-end setup to use **SSH** so PyCharm can push a project's changes to github.

## A) Create and load an SSH key (one-time)

1. Generate a key (accept defaults unless you already have one):

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter for default path (~/.ssh/id_ed25519)
# Optionally set a passphrase
```

2. Start the agent and add your key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

* If you set a passphrase, you’ll be prompted once; your desktop keyring may remember it.

3. Add the **public** key to GitHub:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the whole line, then in GitHub: **Settings → SSH and GPG keys → New SSH key** → paste → Save.

4. Test the auth:

```bash
ssh -T git@github.com
```

You should see a “Hi <username>! You’ve successfully authenticated…” message.

## B) Point your local repo at the SSH URL

In your project folder:

```bash
git remote -v
# if you see https://..., switch it to SSH:
git remote set-url origin git@github.com:<USERNAME>/<REPO>.git
git remote -v   # confirm it shows git@github.com:...
```

## C) Configure PyCharm to use SSH

1. **Git executable**:
   PyCharm → **Settings/Preferences → Version Control → Git**

* Ensure “Path to Git executable” points to your system `git` (PyCharm usually auto-detects).

2. **SSH handling**:
   PyCharm → **Settings/Preferences → Tools → SSH Configurations**

* You usually don’t need to add anything here; PyCharm uses your system OpenSSH by default.
  PyCharm → **Settings/Preferences → Version Control → Git**
* Make sure **SSH executable** is **Native** (not “Built-in”).

3. **Clear any old HTTPS login** (so PyCharm stops prompting for a password/token):
   PyCharm → **Settings/Preferences → Version Control → GitHub**

* Remove any stored GitHub accounts tied to HTTPS.

4. **Map the project to Git** (if not already):
   VCS → **Enable Version Control Integration…** → choose **Git**.

5. **Trust the GitHub host key** (first time from inside PyCharm it may ask):

* If prompted “Do you trust the host github.com?”, accept.

# D) Push from PyCharm

* VCS → **Commit** → **Commit and Push** (or the **Push** action).
* If your SSH key has a passphrase and the agent/keyring isn’t holding it yet, you’ll get a prompt once.

---

## Common pitfalls & quick fixes

* **Still seeing password prompts?** Your remote is still HTTPS. Run:

  ```bash
  git remote -v
  git remote set-url origin git@github.com:<USERNAME>/<REPO>.git
  ```
* **Key not used / asks every time:** Ensure the agent has the key:

  ```bash
  ssh-add -l               # list keys loaded
  ssh-add ~/.ssh/id_ed25519
  ```

  On Linux desktops, your keyring can auto-load keys on login. If not, add the `eval "$(ssh-agent -s)"` and `ssh-add` to your shell init or use your DE’s keyring settings.
* **Multiple keys / multiple GitHub accounts:** Use `~/.ssh/config`:

  ```
  Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
  ```
* **Permissions error:** Make sure `~/.ssh` is `700` and private key is `600`:

  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_ed25519
  ```

That’s it—once the remote is SSH and your key is added, PyCharm pushes should “just work.” If anything still blocks you, paste your `git remote -v` and the output of `ssh -T git@github.com`, and I’ll zero in on it.
