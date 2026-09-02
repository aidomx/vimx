---
outline: deep
---

# Settings & Themes

Configure editor settings and switch themes with `vimx`.

## Setting Editor Options

```bash
vimx set number
vimx set relativenumber
vimx set tabstop 4
vimx set expandtab
vimx set clipboard unnamedplus
```

This modifies `core/settings.vim`.

## Theme Manager

```bash
vimx theme
```

Opens an interactive theme selector with preview.

### Available Themes

| Theme | Plugin | Style |
| --- | --- | --- |
| Gruvbox (default) | `morhetz/gruvbox` | Retro, warm |
| Seoul256 | `junegunn/seoul256.vim` | Low-contrast |

### Installing New Themes

```bash
# Add theme plugin
vimx add dracula/vim

# Switch to it
vimx theme
# Select "dracula" from the list
```

### Manual Theme Switch

Edit `utils/ui.vim`:

```vim
colorscheme dracula
set background=dark
```

Or in `utils/custom.vim`:

```vim
colorscheme dracula
highlight Normal guibg=#282a36
```

## Resetting Settings

```bash
# Reset all settings to defaults
vimx reset

# Reset specific type
vimx reset settings
vimx reset plugins
vimx reset mappings
```

This restores the `.default.vim` template files.

## Mapping Editor

```bash
# Interactive mapping editor
vimx editmap

# List all mappings
vimx editmap list

# Add a mapping
vimx editmap add '<leader>custom' ':YourCommand<CR>'

# Remove a mapping
vimx editmap remove '<leader>custom'

# Search mappings
vimx editmap search 'leader'
```

## Related

- [Key Mappings](/keymappings) — Full shortcut reference
- [Customization](/customization) — Advanced customization
