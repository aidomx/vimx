---
outline: deep
---

# Prerequisites

Packages vimx needs, and what each one is used for.

## 📋 Requirements Overview

| Category | Tool | Needed for | Required? |
|----------|------|------------|-----------|
| Core | Vim or Neovim | The editor | ✅ One of them |
| Core | Git | Cloning the repo, plugins | ✅ Required |
| Core | curl | Downloading vim-plug, the installer | ✅ Required |
| Core | Node.js + npm | coc.nvim (LSP), prettier | ⚠️ Recommended |
| Optional | jq | `vimx theme`, `vimx search` | 🔵 Optional |
| Optional | bc | File sizes in `vimx coc` | 🔵 Optional |
| Tools | clang, clangd, clang-format | C/C++ diagnostics and formatting | 🔵 Optional |
| Tools | shellcheck, shfmt | Shell linting and formatting | 🔵 Optional |
| Tools | ripgrep | `:Rg` and the `gg` mapping | 🔵 Optional |
| Tools | black, flake8, autopep8 | Python formatting and linting | 🔵 Optional |
| Tools | Go | Go development | 🔵 Optional |
| Tools | cmake, ninja | Build tools | 🔵 Optional |
| Tools | rbot | C build tool (see [Installation](installation.md#rbot)) | 🔵 Optional |

The installer checks only for **git, curl, and vim or nvim**. Everything else is
optional, and the installer offers the Tools rows as a menu (see
[Installation](installation.md#optional-tools)).

---

## ✅ Required

### Editor

- **Vim** 8.2 or newer, or **Neovim** 0.7 or newer. One is enough.

### Core Packages

- **Git**
- **curl**

### Node.js

- **Node.js and npm.** coc.nvim (the language server client) needs Node.js at
  runtime, and prettier is installed through npm. Without Node.js, the editor
  still opens, but LSP and prettier-based formatting do not work.

---

## 🧰 Optional

### vimx CLI

- **jq**: JSON parsing for `vimx theme` and `vimx search`
- **bc**: calculator for file sizes in `vimx coc`

### Language Tools

- **clang, clangd, clang-format**: C/C++ diagnostics (coc-clangd) and save-time
  formatting (ALE with clang-format)
- **shellcheck, shfmt**: shell diagnostics and `:Format`
- **black, flake8, autopep8**: Python
- **Go**: Go development (`gofmt` ships with Go)
- **cmake, ninja**: build tools

### Search

- **ripgrep**: used by `:Rg` (the `gg` mapping). Without it, `gg` does not work.
- **fzf**: used by `:Files`, `:Buffers`, and `:Rg`. It is installed through its vim-plug plugin.

---

## 🖥️ Platform Installation

### Termux (Android)

```bash
# Required
pkg update && pkg upgrade
pkg install vim-python nodejs git curl jq bc

# Recommended
pkg install shfmt shellcheck
```

### Arch Linux / proot-distro

```bash
# Required
sudo pacman -Syu
sudo pacman -S vim neovim nodejs npm git curl jq bc

# Recommended
sudo pacman -S shfmt shellcheck
```

### Ubuntu / Debian

```bash
# Required
sudo apt update && sudo apt upgrade
sudo apt install vim neovim nodejs npm git curl jq bc

# Recommended
sudo apt install shfmt shellcheck
```

### Fedora / RHEL / CentOS

```bash
# Required
sudo dnf update
sudo dnf install vim neovim nodejs npm git curl jq bc

# Recommended
sudo dnf install shfmt shellcheck
```

### macOS

```bash
# Required
brew install vim neovim node git jq bc

# Recommended
brew install shfmt shellcheck
```

---

## 🛠️ Language-Specific Tools

### Web Development

```bash
# Global packages (Prettier can also be installed locally per project)
npm install -g typescript prettier eslint
```

### C/C++ Development

**Termux:** `pkg install clang gdb cmake make`

**Arch:** `sudo pacman -S clang gcc gdb cmake make`

**Ubuntu:** `sudo apt install clang gcc gdb cmake build-essential`

**Formatters:** `sudo apt install clang-format` or `pkg install clang`

### Python Development

```bash
pip3 install black flake8 autopep8 pylint
```

### Go Development

**Termux:** `pkg install golang`

**Arch:** `sudo pacman -S go`

**Ubuntu:** [Download from go.dev](https://go.dev/dl/)

**Tools:** `go install golang.org/x/tools/gopls@latest`

### PHP/Laravel Development

**Termux:** `pkg install php composer`

**Arch:** `sudo pacman -S php composer`

**Ubuntu:** `sudo apt install php php-cli php-mbstring php-xml composer`

**Tools:** `composer global require friendsofphp/php-cs-fixer phpstan/phpstan`

### Bash/Shell Development

```bash
# Formatters & linters
pkg install shfmt shellcheck     # Termux
sudo pacman -S shfmt shellcheck  # Arch
sudo apt install shfmt shellcheck  # Ubuntu
brew install shfmt shellcheck    # macOS
```

---

## 🎨 Fonts (Optional)

For better visual experience, install a Nerd Font:

```bash
# Desktop Linux/macOS
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh FiraCode
```

Recommended fonts:
- FiraCode Nerd Font
- JetBrains Mono Nerd Font
- Hack Nerd Font

---

## ✅ Verification

After installing, verify everything works:

```bash
# Check core
vim --version
node --version
git --version

# Check vimx dependencies
jq --version
bc --version

# Check formatters (if installed)
shfmt --version
prettier --version
black --version
```

### Health Check

```bash
vimx doctor
```

---

## 🐛 Common Issues

### Node.js Version Too Old

```bash
# Termux
pkg upgrade nodejs

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### jq Not Found

```bash
# Termux
pkg install jq

# Arch
sudo pacman -S jq

# Ubuntu
sudo apt install jq

# macOS
brew install jq
```

### shfmt Not Found

```bash
# Termux
pkg install shfmt

# Arch
sudo pacman -S shfmt

# Ubuntu
sudo apt install shfmt

# macOS
brew install shfmt
```

---

## 🔜 Next Steps

After installing prerequisites:

1. Proceed to [Installation Guide](installation.md)
2. Or quick install: `curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash`

---

[← Home](/) | [Installation Guide →](installation.md)
