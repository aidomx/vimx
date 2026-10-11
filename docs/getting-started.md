---
outline: deep
---

# Quick Start

Get up and running with vimx in under 5 minutes.

## Prerequisites

You need `git`, `curl`, and either `vim` or `nvim`. Node.js is needed for LSP and prettier.

```bash
# Termux
pkg install vim git curl nodejs

# Arch
sudo pacman -S vim git curl nodejs npm

# Ubuntu/Debian
sudo apt install vim git curl nodejs npm
```

## One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

The installer will:

1. Check for `git`, `curl`, and `vim` or `nvim`
2. Install the configuration to `~/.config/vim` (from a local folder, or cloned from GitHub)
3. Ask whether to back up or replace your `~/.vimrc`, and set up `~/.config/nvim/init.vim` if Neovim is installed
4. Ask which `coc-settings.json` to use (minimal is the default)
5. Install vim-plug (or packer or lazy) and the plugins
6. Install the `vimx` CLI tool
7. Offer optional tools (Node, Python, Go, C/C++, shell, ripgrep, build tools, rbot) as a numbered menu

See the full [Installation Guide](installation.md) for each prompt.

## What You Get

After installation, you have:

- **IDE-like Vim** with LSP, completion, and debugging
- **30+ plugins** pre-configured for full-stack development
- **vimx CLI** for managing everything from the terminal

## First Steps

```bash
# Check everything is working
vimx doctor

# See available commands
vimx help

# Open Vim
vim
```

## Key Shortcuts to Know

| Shortcut     | Action            |
| ------------ | ----------------- |
| `tt`         | Toggle file tree  |
| `ff`         | Find file in tree |
| `nf`         | NERDTree focus    |
| `pf`         | Pick file (fzf)   |
| `gg`         | Grep (needs ripgrep) |
| `gd`         | Go to definition  |
| `<leader>fmt`| Format code       |
| `<leader>w`  | Save file         |

> Leader key is **Space**.

## Next Steps

- [Installation Guide](/installation) — Manual install steps
- [Key Mappings](/keymappings) — All keyboard shortcuts
- [vimx CLI](/vimx) — Command reference
- [Language Guides](/languages/web) — Setup for your stack
