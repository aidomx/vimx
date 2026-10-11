---
outline: deep
---

# Installation Guide

Installation instructions for vimx.

## 📦 Automated Installation (Recommended)

Run the installer with curl:

```bash
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

::: warning Which code gets installed
The `curl` command clones the `main` branch of `github.com/aidomx/vimx`. Your
local copy of the repository is **not** used. If you are installing an unreleased
or local change, use [Install from a local folder](#install-from-a-local-folder)
instead.
:::

The installer runs these steps in order:

1. **Check dependencies.** Requires `git`, `curl`, and at least one of `vim` or `nvim`.
2. **Install the configuration.** From a local folder it copies the folder to
   `~/.config/vim`. From `curl | bash` it clones from GitHub.
3. **Set up `~/.vimrc`.** If you already have one, it is backed up and you choose:
   replace, append the `source` line, or keep it.
4. **Set up Neovim** (only if `nvim` is installed). Creates or updates
   `~/.config/nvim/init.vim` so it sources the same configuration. Same choices as step 3.
5. **Choose `coc-settings.json`.** Minimal (default, recommended for phones and
   Termux) or full (includes the long Tailwind/Headwind class lists). The file is
   copied to `~/.vim/coc-settings.json`, and to `~/.config/nvim/coc-settings.json` if Neovim is installed.
6. **Choose a plugin manager.** vim-plug (Vim and Neovim), packer.nvim, lazy.nvim,
   or skip if one is already installed.
7. **Install plugins.** From a local install, you are first asked whether to clean existing plugins.
8. **Install the `vimx` command** into `/usr/bin` (or `$PREFIX/bin` on Termux). It uses `sudo` when needed.
9. **Optional tools.** Shows a list and asks whether to install them. See [Optional Tools](#optional-tools).

Most prompts have a default. Pressing Enter selects it. If there is no answer
(for example, the terminal is closed), the installer uses the default.

## 🧰 Optional Tools

After the main installation, the installer shows this list **before** asking anything:

```
Would you like to install recommended tools?

  1) Node.js + npm (web development, prettier)
  2) Python tools (black, flake8, autopep8)
  3) Go (Go development)
  4) C/C++ tools (clang, clangd, clang-format)
  5) Shell tools (shellcheck, shfmt)
  6) ripgrep (used by :Rg and the gg mapping)
  7) Build tools (cmake, ninja)
  8) rbot (C build tool, from a path or git URL)

Install optional tools? [y/N]:
```

If you answer `y`, you then choose the numbers to install, separated by spaces
(for example `1 4 6`). Enter or `a` installs items 1–7. **rbot (8) is never
installed by default**; you must select it.

Each package shows a spinner while it installs. If a package fails, the last few
lines of its log are shown and the installer moves on to the next package.

::: tip sudo
For `apt` and `pacman`, the installer asks for your sudo password once, at the start.
Packages install in the background, so the password is requested before that, not during.
:::

### rbot

Choosing 8 asks for a source:

- **Enter** clones `https://github.com/aidomx/rbot.git` into `~/.local/src/rbot`.
- **A folder path** builds from that folder.
- **A `.tar.gz` path** extracts it, then builds.
- **A git URL** clones that URL.
- **`-`** skips rbot.

rbot is built with `bash install.sh --dev`. rbot detects its own platform.

## ⚙️ Manual Installation

If you prefer to install by hand, follow these steps.

### 1. Install Prerequisites

Make sure `git`, `curl`, and `vim` or `nvim` are installed. See [Prerequisites](prerequisites.md).

### 2. Clone the Repository

```bash
git clone https://github.com/aidomx/vimx.git ~/.config/vim
```

### 3. Create or Edit `~/.vimrc`

```vim
if filereadable(expand('~/.config/vim/init.vim'))
  source ~/.config/vim/init.vim
endif
```

For Neovim, create `~/.config/nvim/init.vim` with the same block.

### 4. Choose `coc-settings.json`

Copy one of the two files from the repository:

```bash
# Minimal (recommended)
cp ~/.config/vim/coc-settings.minimal.json ~/.vim/coc-settings.json

# Full (includes Tailwind/Headwind class lists)
cp ~/.config/vim/coc-settings.json ~/.vim/coc-settings.json
```

For Neovim, copy to `~/.config/nvim/coc-settings.json` instead.

### 5. Install a Plugin Manager

vim-plug works for both Vim and Neovim:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

For Neovim, use `~/.local/share/nvim/site/autoload/plug.vim` as the path.

### 6. Install Plugins

Open Vim or Neovim and run:

```vim
:PlugInstall
```

Wait for all plugins to finish downloading.

### 7. Install the vimx Tool (Optional)

```bash
sudo cp ~/.config/vim/vimx.sh /usr/bin/vimx
sudo chmod +x /usr/bin/vimx
```

## 🔄 Updating

### Update Plugins

```bash
vimx update
```

Or inside Vim:

```vim
:PlugUpdate
```

### Update the Configuration

```bash
vimx system-update
```

Or manually:

```bash
cd ~/.config/vim && git pull origin main
```

## 🗑️ Uninstallation

```bash
# Configuration
rm -rf ~/.config/vim

# vim-plug and plugins
rm -rf ~/.vim/autoload/plug.vim ~/.vim/plugged

# Neovim config written by the installer (only if you did not keep your own)
rm -f ~/.config/nvim/init.vim

# coc settings
rm -f ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json

# vimx command
sudo rm -f /usr/bin/vimx
```

Remove or edit `~/.vimrc` as well. The installer backed up any previous file as `~/.vimrc.backup.<timestamp>`.

## 🐛 Installation Troubleshooting

### The installer stops right after a question

Run the installer from a terminal, not from a pipe you started through another
program. The prompts read from `/dev/tty`. If you still see this, run the
[local install](#install-from-a-local-folder) instead.

### Install from a Local Folder

If you have a checkout or an extracted archive, run the installer from that folder.
It copies the folder to `~/.config/vim`:

```bash
cd ~/vimx-src
bash install.sh
```

### Permission Denied

```bash
chmod -R u+w ~/.config/vim ~/.vim
```

### Plugin Installation Fails

1. Check your connection.
2. Update vim-plug (see step 5 above).
3. Run `:PlugInstall` again, or `vimx update`.

### Git or curl Not Found

```bash
# Termux
pkg install git curl

# Arch Linux
sudo pacman -S git curl

# Ubuntu/Debian
sudo apt install git curl
```

### Node.js Not Found

Node.js is only needed for prettier and some language servers.

```bash
# Termux
pkg install nodejs

# Arch Linux
sudo pacman -S nodejs npm

# Ubuntu/Debian
sudo apt install nodejs npm
```

## 📱 Platform-Specific Installation

### Termux (Android)

```bash
pkg update && pkg upgrade
pkg install vim git curl nodejs
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

Termux is detected as "native" only when the shell has `$PREFIX` set and
`uname -o` reports `Android`. Ubuntu or Arch inside `proot-distro` are treated as ordinary Linux.

### Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S vim neovim nodejs npm git curl
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

### Ubuntu/Debian

```bash
sudo apt update && sudo apt upgrade
sudo apt install vim neovim nodejs npm git curl
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

## ✅ Verify the Installation

```bash
vimx version
vimx doctor
```

Then open Vim and check:

```vim
:PlugStatus
:CocInfo
```

## 🔜 Next Steps

1. Read the [Quick Start Guide](quick-start.md)
2. Learn the [Key Mappings](keymappings.md)
3. Check the [Language Guides](/languages/web)
4. Customize your setup with the [Customization Guide](customization.md)

---

[← Home](/)
