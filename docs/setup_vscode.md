# Setup VSCode/VSCodium for Python Development (Linux - Debian)

> NOTE: This is a shell script that configures VS Code/VSCodium, installs extensions,
> and sets editor settings.

## Install The Base Editor/IDE

### Install VSCodium (Open-Source) <span style="color:green;">[RECOMMENDED]</span>

> Note that while VSCodium is free, open-source, and free of telemetry, **some extensions will not be available, unless installed manually using the corresponding .vsix file**.

1. Install the VSCodium signing key

   ```bash
   wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
   | sudo gpg --dearmor -o /usr/share/keyrings/vscodium-archive-keyring.gpg
   ```

2. Add the VSCodium APT repository

   ```bash
   echo "deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] \
   https://download.vscodium.com/debs vscodium main" \
   | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null
   ```

3. Update Sources and Install

   ```bash
   sudo apt update -y
   sudo apt install codium -y
   ```

4. OPTIONAL: Uninstall VSCodium

   ```bash
   sudo apt remove codium
   sudo rm /etc/apt/sources.list.d/vscodium.list
   sudo rm /usr/share/keyrings/vscodium-archive-keyring.gpg
   sudo apt update
   ```

### -OR- Install VSCode (Proprietary)

Note that this script strips out Microsoft's telemetry and access to the extension store! You can turn some or all of that off by editing the script. But if you are going to use it as-is, you might as well just use VSCodium (Free and Open-Source Without Telemetry). _**However, VSCode has wider support for extensions.**_

1. Install Microsoft's signing key

   ```bash
   wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
   sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
   rm -f packages.microsoft.gpg
   ```

2. Add the VS Code APT repository

   ```bash
   echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] \
   https://packages.microsoft.com/repos/code stable main" | \
   sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
   ```

3. Update Sources and Install

   ```bash
   sudo apt update -y
   sudo apt install codium -y
   ```

4. OPTIONAL: Uninstall VSCode

   ```bash
   sudo apt remove code
   sudo rm /etc/apt/sources.list.d/vscode.list
   sudo rm /usr/share/keyrings/packages.microsoft.gpg
   sudo apt update
   ```

### Make Sure the [UV](https://docs.astral.sh/uv/) Python Project/Package Management Tool Is Installed

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Setup The Development Environment

> You shouldn't run unknown scripts. Consider reviewing [bootstrap_python_vscode_setup.sh](https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/bootstrap_python_vscode_setup.sh) before running it.

### Implement My Setup for Python Development

```bash
curl -fL https://raw.githubusercontent.com/travisseymour/useful_stuff/main/docs/bootstrap_python_vscode_setup.sh -o bootstrap_python_vscode_setup.sh
less bootstrap_python_vscode_setup.sh
chmod +x bootstrap_python_vscode_setup.sh
./bootstrap_python_vscode_setup.sh
```

## For Your Information: Current Extensions Installed By Script:

- **Prettier** — formatter for JS/TS/JSON/Markdown (not Python)
- **Material Icon Theme** — nice file/folder icons
- **Peacock** — colorize your workspace (useful when many folders)
- **Auto-open Markdown Preview** — convenient documentation viewer
- **IntelliCode** — ML-enhanced completions (for Python too)
- **VSCode YAML** — YAML language support + schema validation
- **GitLens** — best-in-class Git history / blame / insights
- **Git Graph** — visual commit history graph
- **Rainbow CSV** — CSV/TSV column highlighting + tools
- **Code Snapshot** — export highlighted code as images
- **TODO Highlight** — colorize TODO/FIXME/etc in source
- **Bookmarks** — jump between code locations fast
- **Even Better TOML** — TOML syntax + IntelliSense
- **Better Comments** — categorize comments (TODO, NOTE, WARN…)
- **Python Indent** — smarter indentation rules for Python
- **Path Intellisense** — autocomplete filesystem paths
- **Import Cost** — shows estimated import cost for JS/TS (optional)
- **Test Explorer UI** — unified test UI (pytest integrates well)
- **JSON Schema Store** — auto-schemas for JSON/YAML configs
- **UV Toolkit** — first-class uv integration (commands + UI)
- **Project Manager** — Easiy manage, track, and switch between projects
- **qt** — Qt tools (Designer/QML support, syntax, build helpers)
- **PySide6 UI converter** — .ui → .py generator
- **Official Python extension** — debugging, venv detection, etc.
- **Jupyter notebooks** — interactive Python
- **AutoDocstring** — insert docstring templates
- **VSCode Python Test Adapter** — Python Test Explorer integration for pytest
- **Code Spell Checker** — English spell-check in code
- **Code Runner** — run code snippets quickly
- **Python Environment Manager** — list/select envs
- **AREPL** — live auto-run Python (great for quick tests)
- **Python Snippets** — convenience code templates
- **Error Lens** — inline error/warning markers (very useful)
- **Official Ruff extension** — linting, formatting, import sorting
- **Sourcery** — refactoring suggestions for Python code
