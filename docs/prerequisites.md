---
outline: deep
---

# Prerequisites

Required packages and dependencies for vimx.

## 📋 Requirements Overview

| Category | Tool | Purpose | Required? |
|----------|------|---------|-----------|
| Core | Vim/Neovim | Text editor | ✅ Required |
| Core | Git | Version control | ✅ Required |
| Core | Node.js + npm | Coc.nvim (LSP) | ✅ Required |
| Core | curl/wget | Downloads, API | ✅ Required |
| CLI | jq | JSON parsing | ✅ Required |
| CLI | bc | Calculations | ✅ Required |
| Formatter | shfmt | Shell formatting | ⚠️ Recommended |
| Formatter | black/autopep8 | Python formatting | ⚠️ Recommended |
| Formatter | gofmt | Go formatting | ⚠️ Recommended |
| Formatter | clang-format | C/C++ formatting | ⚠️ Recommended |
| Formatter | php-cs-fixer | PHP formatting | ⚠️ Recommended |
| Formatter | prettier | JS/TS/HTML/CSS formatting via Neoformat | ⚠️ Recommended |
| Linter | shellcheck | Shell linting | ⚠️ Recommended |
| Fallback | python3 | JSON fallback | 🔵 Optional |

---

## ✅ Required

These **must** be installed for vimx to work properly.

### Core Packages

- **Vim** (8.2+) or **Neovim** (0.7+)
- **Git** - Version control
- **Node.js** (14+) and **npm** - Required for Coc.nvim
- **curl** or **wget** - For downloading and API calls

### vimx CLI Dependencies

- **jq** - JSON processor (used by `vimx theme`, `vimx search`)
- **bc** - Calculator (used for file size calculations)

---

## ⚠️ Recommended

These enhance the experience and are needed for specific features.

### Formatters

- **shfmt** - Shell script formatting (`:Neoformat` on .sh files)
- **black** or **autopep8** - Python formatting
- **gofmt** - Go formatting (included with Go)
- **clang-format** - C/C++ formatting
- **php-cs-fixer** - PHP formatting
- **prettier** - JS/TS/HTML/CSS formatting via Neoformat

### Linters

- **shellcheck** - Shell script linting

---

## 🔵 Optional

Nice-to-have tools that improve the experience.

- **python3** - Fallback JSON parsing when jq unavailable
- **fzf** - Fuzzy finder
- **ripgrep** - Better grep
- **fd** - Better find
- **bat** - Better cat

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
