---
outline: deep
---

# Language Manager

Enable, disable, and configure language support with `vimx lang`.

## Listing Languages

```bash
vimx lang list
```

Shows all available language configurations with **ftdetect** and **syntax** status:

```
┌────┬──────────────┬──────────┬────────┐
│ No │ Language     │ ftdetect │ syntax │
├────┼──────────────┼──────────┼────────┤
│  1 │ bash         │    ✓     │   ✓    │
│   2 │ c            │    ✓     │   ✓    │
│   3 │ go           │    ✓     │   ✓    │
│   4 │ php          │    ✓     │   ✓    │
│   5 │ python       │    ✓     │   ✓    │
│   6 │ rust         │    ✗     │   ✗    │
└────┴──────────────┴──────────┴────────┘
```

## Adding a Language

### Quick Add (with defaults)

```bash
vimx lang add rust
```

This creates 3 files:
1. **`langs/rust.vim`** — Language settings, indentation, keymaps
2. **`ftdetect/rust.vim`** — Filetype detection (`*.rs` → rust)
3. **`syntax/rust.vim`** — Syntax highlighting rules

And adds `runtime! langs/rust.vim` to `init.vim`.

### Interactive Scaffold

For more control over file extensions and comment style:

```bash
vimx lang scaffold rust
```

This prompts you for:
- **File extensions** — e.g. `rs,toml`
- **Comment style** — `//`, `#`, `--`, or `;`

Then creates all 3 files with your preferences.

## Enabling a Language

```bash
vimx lang enable rust
```

Uncomments the `runtime! langs/rust.vim` line in `init.vim`.

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

## Language Info

```bash
vimx lang info rust
```

Shows status, file size, and whether ftdetect/syntax files exist:

```
Language Information: rust

  Status    : Enabled
  File      : ~/.config/vim/langs/rust.vim
  Size      : 256 bytes
  Lines     : 12
  Created   : 2026-09-01

  ftdetect: exists
  syntax:   exists
```

## Custom Language Support

Each language can have up to 3 files:

```
~/.config/vim/
├── langs/rust.vim       # Settings, indentation, keymaps
├── ftdetect/rust.vim    # Filetype detection rules
└── syntax/rust.vim      # Syntax highlighting
```

### langs/rust.vim

Language-specific settings and keymaps:

```vim
" Rust Development
autocmd FileType rust setlocal shiftwidth=4 tabstop=4
autocmd FileType rust setlocal commentstring=//\ %s

" Key mappings
autocmd FileType rust nnoremap <buffer> <leader>rb :!cargo build<CR>
autocmd FileType rust nnoremap <buffer> <leader>rr :!cargo run<CR>
```

### ftdetect/rust.vim

Filetype detection — tells Vim which files are Rust:

```vim
" Filetype detection for rust
autocmd BufRead,BufNewFile *.rs set filetype=rust
autocmd BufRead,BufNewFile *.toml set filetype=toml
```

### syntax/rust.vim

Syntax highlighting rules:

```vim
" Syntax highlighting for rust
if exists("b:current_syntax")
  finish
endif

syn keyword rustKeyword fn let mut pub use mod
syn keyword rustKeyword struct enum trait impl
syn match rustComment "//.*$"
syn region rustString start='"' end='"'
syn match rustNumber "\<\d\+\>"

hi def link rustKeyword Keyword
hi def link rustComment Comment
hi def link rustString  String
hi def link rustNumber  Number

let b:current_syntax = "rust"
```

### When to Use Custom Syntax

For simple languages, the scaffolded syntax file works well. For complex languages, consider installing a plugin:

```bash
# Option 1: Use the scaffolded syntax (basic)
vimx lang scaffold rust

# Option 2: Install a full syntax plugin (recommended for popular languages)
vimx add rust-lang/rust.vim
```

## Built-in Languages

| Language | File | ftdetect | syntax | LSP Extension |
| --- | --- | --- | --- | --- |
| JavaScript/TypeScript | `web.vim` | ✓ | ✓ | `coc-tsserver` |
| C/C++ | `c.vim` | ✓ | ✓ | `coc-clangd` |
| Python | `python.vim` | ✓ | ✓ | `coc-pyright` |
| Go | `go.vim` | ✓ | ✓ | `coc-go` |
| PHP/Laravel | `php.vim` | ✓ | ✓ | `coc-phpls` |
| Bash | `bash.vim` | ✓ | ✓ | — |

## Removing a Language

```bash
vimx lang remove rust
```

This:
1. Removes `runtime! langs/rust.vim` from `init.vim`
2. Asks to delete `langs/rust.vim`
3. Asks to delete `ftdetect/rust.vim` and `syntax/rust.vim`

## Related

- [Language Guides](/languages/web) — Setup guides per language
- [Customization](/customization) — Adding custom language configs
- [Plugins](/vimx-plugins) — Installing language plugins
