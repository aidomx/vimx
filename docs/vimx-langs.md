---
outline: deep
---

# Language Manager

Enable, disable, and configure language support with `vimx lang`.

## Listing Languages

```bash
vimx lang list
```

Shows all available language configurations in `langs/` directory.

## Enabling a Language

```bash
vimx lang enable rust
```

This:
1. Creates `langs/rust.vim` if it doesn't exist
2. Adds `runtime! langs/rust.vim` to `init.vim`

## Disabling a Language

```bash
vimx lang disable php
```

Comments out the `runtime! langs/php.vim` line in `init.vim`.

## Editing Language Config

```bash
vimx lang edit python
```

Opens `langs/python.vim` in your editor.

## Adding a New Language

```bash
# 1. Create the config file
vimx lang edit rust

# 2. Add your configuration
autocmd FileType rust set tabstop=4 shiftwidth=4
autocmd FileType rust nnoremap <leader>rb :!cargo build<CR>

# 3. Enable it
vimx lang enable rust

# 4. Install LSP
# In Vim: :CocInstall coc-rust-analyzer
```

## Built-in Languages

| Language | File | LSP Extension |
| --- | --- | --- |
| JavaScript/TypeScript | `web.vim` | `coc-tsserver` |
| C/C++ | `c.vim` | `coc-clangd` |
| Python | `python.vim` | `coc-pyright` |
| Go | `go.vim` | `coc-go` |
| PHP/Laravel | `php.vim` | `coc-phpls` |
| Bash | `bash.vim` | — |

## Related

- [Language Guides](/languages/web) — Setup guides per language
- [Customization](/customization) — Adding custom language configs
