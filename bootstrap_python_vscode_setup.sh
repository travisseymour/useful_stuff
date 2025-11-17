#!/usr/bin/env bash
set -euo pipefail

echo "=== VS Code / VSCodium Python IDE bootstrap (UV-only version) ==="

# -------------------------
# 1. Detect editor binary
# -------------------------
EDITOR_BIN=""
CONFIG_DIR=""

if command -v code >/dev/null 2>&1; then
    EDITOR_BIN="code"
    CONFIG_DIR="${HOME}/.config/Code/User"
    echo "→ Detected VS Code (code)"
elif command -v codium >/dev/null 2>&1; then
    EDITOR_BIN="codium"
    CONFIG_DIR="${HOME}/.config/VSCodium/User"
    echo "→ Detected VSCodium (codium)"
else
    echo "✖ Neither 'code' nor 'codium' found in PATH."
    echo "  Install VS Code or VSCodium first, then re-run this script."
    exit 1
fi

mkdir -p "${CONFIG_DIR}"

# -------------------------
# 2. Install extensions
# -------------------------

EXTENSIONS=(
  # -------------------------------------
  # GENERAL UI / QUALITY OF LIFE
  # -------------------------------------

  "esbenp.prettier-vscode"                 # Prettier — formatter for JS/TS/JSON/Markdown (not Python)
  "PKief.material-icon-theme"              # Material Icon Theme — nice file/folder icons
  "johnpapa.vscode-peacock"                # Peacock — colorize your workspace (useful when many folders)
  "hnw.vscode-auto-open-markdown-preview"  # Auto-open Markdown Preview — convenient documentation viewer
  "visualstudioexptteam.vscodeintellicode" # IntelliCode — ML-enhanced completions (for Python too)
  "redhat.vscode-yaml"                     # YAML language support + schema validation
  "eamodio.gitlens"                        # GitLens — best-in-class Git history / blame / insights
  "mhutchie.git-graph"                     # Git Graph — visual commit history graph
  "mechatroner.rainbow-csv"                # Rainbow CSV — CSV/TSV column highlighting + tools
  "robertz.code-snapshot"                  # Code Snapshot — export highlighted code as images
  "wayou.vscode-todo-highlight"            # TODO Highlight — colorize TODO/FIXME/etc in source
  "alefragnani.bookmarks"                  # Bookmarks — jump between code locations fast
  "tamasfe.even-better-toml"               # Even Better TOML — TOML syntax + IntelliSense
  "aaron-bond.better-comments"             # Better Comments — categorize comments (TODO, NOTE, WARN…)
  "kevinkyang.python-indent"               # Python Indent — smarter indentation rules for Python
  "christian-kohler.path-intellisense"     # Path Intellisense — autocomplete filesystem paths
  "wix.vscode-import-cost"                 # Import Cost — shows estimated import cost for JS/TS (optional)
  "hbenl.vscode-test-explorer"             # Test Explorer UI — unified test UI (pytest integrates well)
  "remcohaszing.vscode-schemastore"        # JSON Schema Store — auto-schemas for JSON/YAML configs
  "the0807.uv-toolkit"                     # UV Toolkit — first-class uv integration (commands + UI)
  "alefragnani.project-manager"            # Project Manager -- Easiy manage, track, and switch between projects 

  # -------------------------------------
  # QT / PYSIDE6 DEVELOPMENT
  # -------------------------------------

  "TheQtCompany.qt"                        # Qt tools (Designer/QML support, syntax, build helpers)
  "AungKhantM.pyside6-ui2py"               # PySide6 UI converter — .ui → .py generator

  # -------------------------------------
  # PYTHON DEVELOPMENT
  # -------------------------------------

  "ms-python.python"                       # Official Python extension — debugging, venv detection, etc.
  "ms-toolsai.jupyter"                     # Jupyter notebooks + interactive Python
  "njpwerner.autodocstring"                # AutoDocstring — insert docstring templates
  "LittleFoxTeam.vscode-python-test-adapter"  # Python Test Explorer integration for pytest
  "streetsidesoftware.code-spell-checker"     # Code Spell Checker — English spell-check in code
  "formulahendry.code-runner"              # Code Runner — run code snippets quickly
  "ms-python.vscode-python-envs"           # Python Environment Manager — list/select envs
  "almenon.arepl"                          # AREPL — live auto-run Python (great for quick tests)
  "cstrap.python-snippets"                 # Python Snippets — convenience code templates
  "usernamehw.errorlens"                   # Error Lens — inline error/warning markers (very useful)
  "charliermarsh.ruff"                     # Official Ruff extension — linting, formatting, import sorting
  "sourcery.sourcery"                      # Sourcery — refactoring suggestions for Python code
)


echo
echo "=== Installing extensions using '${EDITOR_BIN}' ==="

for ext in "${EXTENSIONS[@]}"; do
    echo "→ Installing ${ext}"
    if ! "${EDITOR_BIN}" --install-extension "${ext}" >/dev/null 2>&1; then
        echo "   ⚠️  Failed to install ${ext} (may not be in marketplace or you're offline)."
    fi
done

echo
echo "Extensions installed."
echo

# -------------------------
# 3. Write settings.json
# -------------------------

SETTINGS_FILE="${CONFIG_DIR}/settings.json"

if [[ -f "${SETTINGS_FILE}" ]]; then
    backup="${SETTINGS_FILE}.bak-$(date +%s)"
    echo "Backing up existing settings.json to ${backup}"
    cp "${SETTINGS_FILE}" "${backup}"
fi

cat > "${SETTINGS_FILE}" << 'EOF'
{
  "telemetry.telemetryLevel": "off",
  "telemetry.enableTelemetry": false,
  "telemetry.enableCrashReporter": false,
  "workbench.enableExperiments": false,
  "workbench.settings.enableNaturalLanguageSearch": false,

  "update.mode": "manual",
  "update.showReleaseNotes": false,
  "extensions.autoCheckUpdates": false,
  "extensions.autoUpdate": false,

  "extensionsGallery": {
    "serviceUrl": "",
    "cacheUrl": "",
    "itemUrl": ""
  },

  "extensions.ignoreRecommendations": true,
  "extensions.showRecommendationsOnlyOnDemand": true,
  "settingsSync.enabled": false,
  "npm.fetchOnlinePackageInfo": false,

  "editor.inlineSuggest.enabled": false,
  "github.copilot.enable": {
    "*": false
  },

  "workbench.welcomePage.walkthroughs.openOnInstall": false,
  "workbench.startupEditor": "none",

  "python.linting.enabled": false,

  "python.testing.pytestEnabled": true,
  "python.testing.unittestEnabled": false,
  "python.testing.pytestArgs": [
    "tests"
  ],

  "ruff.enable": true,
  "ruff.format.enable": true,
  "ruff.organizeImports": true,

  "editor.formatOnSave": true,
  "window.zoomLevel": 2,

  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 700,

}
EOF

echo "Wrote ${SETTINGS_FILE}"
echo

# -------------------------
# 4. Create user-level tasks.json (Launch Qt Designer)
# -------------------------

TASKS_FILE="${CONFIG_DIR}/tasks.json"

if [[ -f "${TASKS_FILE}" ]]; then
    backup="${TASKS_FILE}.bak-$(date +%s)"
    echo "Backing up existing tasks.json to ${backup}"
    cp "${TASKS_FILE}" "${backup}"
fi

cat > "${TASKS_FILE}" << 'EOF'
{
  // User-level tasks. These are available in all workspaces.
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Launch Qt Designer (PySide6)",
      "type": "shell",
      "command": "${HOME}/bin/launch_qt_designer.sh",
      "problemMatcher": []
    }
  ]
}
EOF

# Note: ${HOME} is not expanded because of the single-quoted EOF.
# VS Code will pass this to the shell, which will expand $HOME at runtime.

echo "Wrote ${TASKS_FILE}"
echo

# -------------------------
# 5. Create Qt Designer launcher helper in ~/bin
# -------------------------

BIN_DIR="${HOME}/bin"
LAUNCHER="${BIN_DIR}/launch_qt_designer.sh"

mkdir -p "${BIN_DIR}"

cat > "${LAUNCHER}" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Qt Designer launcher for PySide6
#
# Prefers:
#   1. pyside6-designer in the project .venv
#   2. System-wide 'designer' (Qt Designer)
#
# Usage:
#   launch_qt_designer.sh
# ------------------------------------------------------------

echo "=== Launching Qt Designer ==="

# If run inside a project with .venv, prefer that
PROJECT_VENV=""
if [[ -d ".venv" ]]; then
    PROJECT_VENV=".venv"
fi

if [[ -n "${PROJECT_VENV}" && -x "${PROJECT_VENV}/bin/pyside6-designer" ]]; then
    echo "→ Found PySide6 designer inside project venv: ${PROJECT_VENV}"
    exec "${PROJECT_VENV}/bin/pyside6-designer" "$@"
    exit 0
fi

# Fallback: system-wide designer
if command -v designer >/dev/null 2>&1; then
    echo "→ Found system-wide Qt Designer"
    exec designer "$@"
    exit 0
fi

echo
echo "✖ Could not find Qt Designer."
echo
echo "If you are using uv and PySide6, from your project directory run:"
echo "    uv add pyside6"
echo "    uv sync"
echo
echo "Then try launching Qt Designer again."
echo
exit 1
EOF

chmod +x "${LAUNCHER}"
echo "Installed Qt Designer launcher helper at ${LAUNCHER}"
echo

# -------------------------
# 6. Create desktop entry for Qt Designer (PySide6)
# -------------------------

DESKTOP_DIR="${HOME}/.local/share/applications"
DESKTOP_FILE="${DESKTOP_DIR}/qt-designer-pyside6.desktop"

mkdir -p "${DESKTOP_DIR}"

cat > "${DESKTOP_FILE}" <<EOF
[Desktop Entry]
Type=Application
Name=Qt Designer (PySide6)
Comment=Qt UI Designer using PySide6 environments
Exec=${LAUNCHER}
Icon=applications-development
Terminal=false
Categories=Development;IDE;
EOF

chmod +x "${DESKTOP_FILE}"
echo "Installed desktop entry at ${DESKTOP_FILE}"
echo "You may need to log out/in or run 'update-desktop-database' for menus to refresh."
echo

# -------------------------
# 7. Require 'uv' and install CLI tools
# -------------------------

echo "=== Checking for 'uv' ==="

if ! command -v uv >/dev/null 2>&1; then
    echo
    echo "✖ 'uv' is not installed."
    echo
    echo "Please install uv first, e.g.:"
    echo
    echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo
    echo "Then re-run this script."
    exit 1
fi

echo "→ 'uv' found"

echo "=== Installing Ruff + Pyright via 'uv tool' ==="
uv tool install ruff pyright

# -------------------------
# 8. Install support for EPIC rules syntax highlighting
# -------------------------

echo
echo "=== Installing EPIC rules syntax extension (.vsix) ==="

VSIX_URL="https://raw.githubusercontent.com/travisseymour/EPICpyRuleSyntax/main/editors/vscode_vscodium/epicrules-syntax-vscode.vsix"
VSIX_DIR="${HOME}/.local/share/vsix"
VSIX_PATH="${VSIX_DIR}/epicrules-syntax-vscode.vsix"

mkdir -p "${VSIX_DIR}"

# Download via curl or wget
if command -v curl >/dev/null 2>&1; then
    echo "→ Downloading .vsix with curl"
    if ! curl -fL "${VSIX_URL}" -o "${VSIX_PATH}"; then
        echo "   ⚠️  Failed to download EPIC rules .vsix from GitHub"
    fi
elif command -v wget >/dev/null 2>&1; then
    echo "→ Downloading .vsix with wget"
    if ! wget -O "${VSIX_PATH}" "${VSIX_URL}"; then
        echo "   ⚠️  Failed to download EPIC rules .vsix from GitHub"
    fi
else
    echo "✖ Neither curl nor wget is available; cannot download EPIC rules .vsix automatically."
    echo "  You can download it manually from:"
    echo "  ${VSIX_URL}"
fi

# Install the vsix if it exists
if [[ -f "${VSIX_PATH}" ]]; then
    echo "→ Installing EPIC rules syntax from ${VSIX_PATH}"
    if ! "${EDITOR_BIN}" --install-extension "${VSIX_PATH}"; then
        echo "   ⚠️  Failed to install EPIC rules .vsix (check editor logs)."
    fi
else
    echo "⚠️  EPIC rules .vsix not found; skipping installation."
fi

# -------------------------
# 9. Summarize
# -------------------------

echo
echo "=== Bootstrap complete ==="
echo "Editor      : ${EDITOR_BIN}"
echo "Config dir  : ${CONFIG_DIR}"
echo "Helper      : ${LAUNCHER}"
echo "Desktop     : ${DESKTOP_FILE}"
echo "Tools       : ruff, pyright (via uv)"
echo "Language    : EPIC Rules"
echo "---"
echo "NOTE: For PySide6 programming, you can open ${EDITOR_BIN}, run the 'Launch Qt Designer' task, or start Designer from your app menu."
