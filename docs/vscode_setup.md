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
