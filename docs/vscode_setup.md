# Setup VSCode/VSCodium for Python Development (Linux - Debian)

> NOTE: This is a shell script that configures VS Code/VSCodium, installs extensions,
> and sets editor settings. You shouldn't run unknown scripts. Consider reviewing [vscode_install.sh](https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/vscode_install.sh) and [vscode_bootstrap_setup.sh](https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/vscode_bootstrap_setup.sh) before running them.

## Install The Base Editor/IDE

[vscode_install.sh](https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/vscode_install.sh)

```bash
curl -fL https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/vscode_install.sh -o vscode_install.sh
less vscode_install.sh
chmod +x vscode_install.sh
./vscode_install.sh
```

## Setup My Python Development Environment

[bootstrap_python_vscode_setup.sh](https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/vscode_bootstrap_setup.sh)

```bash
curl -fL https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/vscode_bootstrap_setup.sh -o vscode_bootstrap_setup.sh
less vscode_bootstrap_setup.sh
chmod +x vscode_bootstrap_setup.sh
./vscode_bootstrap_setup.sh
```

---

## Other Stuff

#### Setup Claude Skills for Jupyter to Marimo conversion

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
