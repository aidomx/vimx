---
outline: deep
---

# Quick Start

Get up and running with vimx in under 5 minutes.

## One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

The installer will:

1. Check and install prerequisites
2. Clone the repository to `~/.config/vim`
3. Set up vim-plug and install all plugins
4. Install the `vimx` CLI tool

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
| `gg`         | Grep (search)     |
| `gd`         | Go to definition  |
| `<leader>fmt`| Format code       |
| `<leader>w`  | Save file         |

> Leader key is **Space**.

## Next Steps

- [Installation Guide](/installation) — Manual install steps
- [Key Mappings](/keymappings) — All keyboard shortcuts
- [vimx CLI](/vimx) — Command reference
- [Language Guides](/languages/web) — Setup for your stack
