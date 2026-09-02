---
outline: deep
---

# Plugin Management

Manage plugins with `vimx` — search, add, remove, enable, disable, and update.

## Adding Plugins

```bash
# Add from GitHub (owner/repo format)
vimx add tpope/vim-fugitive
vimx add preservim/nerdcommenter
vimx add junegunn/fzf.vim
```

This appends a `Plug` line to `core/plugins.vim` and runs `:PlugInstall`.

## Removing Plugins

```bash
vimx remove copilot.vim
```

Removes the `Plug` line and runs `:PlugClean`.

## Enable / Disable

```bash
# Disable without removing
vimx disable copilot.vim

# Re-enable later
vimx enable copilot.vim
```

Disabled plugins are commented out in `plugins.vim`.

## Listing & Info

```bash
# List all plugins with status
vimx list

# Show details for a specific plugin
vimx info nerdtree
```

## Searching

```bash
vimx search "fuzzy finder"
vimx search "git integration"
```

Searches GitHub for matching repositories.

## Updating

```bash
# Update all plugins
vimx update

# Update a specific plugin
vimx update coc.nvim
```

## Cleaning

```bash
vimx clean
```

Removes plugins that are no longer declared in `plugins.vim`.

## Manual Management

You can also edit `~/.config/vim/core/plugins.vim` directly:

```vim
call plug#begin('~/.vim/plugged')

" Your plugins here
Plug 'tpope/vim-surround'

call plug#end()
```

Then run `:PlugInstall` in Vim.

## Related

- [Plugins Reference](/plugins) — Full list of included plugins
- [Customization](/customization) — How to add custom plugins
