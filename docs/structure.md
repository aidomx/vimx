---
outline: deep
---

# Project Structure

Understanding the Vim configuration directory structure and organization.

## 📁 Directory Overview

```
~/.config/vim/                       # repository root
├── init.vim                         # main entry point
├── vimx.sh                          # the vimx command (copied to /usr/bin/vimx)
├── install.sh                       # installer
├── coc-settings.json                # coc.nvim settings, full
├── coc-settings.minimal.json        # coc.nvim settings, minimal (installer default)
├── core/                            # core configuration
│   ├── settings.vim                 # editor settings
│   ├── mappings.vim                 # key mappings
│   ├── plugins.vim                  # plugin declarations (vim-plug)
│   ├── coc.vim                      # coc.nvim extensions
│   ├── nvim.vim                     # Neovim-only settings
│   └── theme.vim, fonts.vim, vim.vim
├── langs/                           # language modules
│   ├── bash.vim, c.vim, go.vim, python.vim, php.vim
│   ├── web-basic.vim, web.vim, web-auto.vim, js.vim, ts.vim
│   └── android.vim
├── frameworks/                      # framework modules
│   ├── laravel.vim
│   └── nextjs.vim
├── utils/                           # utility modules
│   ├── completion.vim               # coc completion and LSP mappings
│   ├── formatting.vim               # FormatFile() and format-on-save
│   ├── ui.vim                       # statusline, NERDTree, GitGutter
│   ├── termux.vim                   # Termux-only settings
│   └── autopairs.vim                # delimitMate settings and toggle
├── commands/                        # vimx subcommands (sourced by vimx.sh and install.sh)
│   ├── install.sh, optional.sh, setup_vimrc.sh, setup_coc.sh, clone.sh, ...
│   ├── doctor.sh, plugin/, coc/, backup/, language/, help/
├── lib/                             # shared shell helpers
│   ├── prompt.sh                    # ask(): reads answers from /dev/tty
│   ├── execs.sh                     # vimx_editor(), vimx_run_plug_cmd()
│   ├── progress.sh                  # spinner and progress bar
│   ├── logging.sh, colors.sh, fs.sh, paths.sh, table.sh
├── backups/                         # backup archives (kept by you, ignored when empty)
├── syntax/                          # custom syntax files (for example rupa.vim)
├── ftdetect/                        # filetype detection for custom languages
├── LICENSE, README.md, SECURITY.md, CONTRIBUTING.md, .gitignore
```

The documentation site source lives in a separate `docs/` archive, not in this
tree. See [Installation](installation.md) for how the files are installed.

## 🔧 Core Files

### init.vim

The main entry point that loads all other configuration files.

```vim
" Main configuration entry point
" Loads in this order:
" 1. Core settings
" 2. Plugins
" 3. UI configuration
" 4. Language configs
" 5. Framework configs
" 6. Utility configs
" 7. Custom mappings
```

**Purpose:** Orchestrates loading of all configuration modules

**Key sections:**

- Plugin initialization
- Module loading
- Post-configuration hooks

### core/settings.vim

Basic Vim editor settings and behaviors.

**Contains:**

- Line numbers and relative numbers
- Indentation settings (tabs, spaces)
- Search settings (highlighting, ignore case)
- Backup, undo, and swap file configuration (`nobackup` with `writebackup`, so no backup copy is made on every save)
- Clipboard integration
- Mouse support
- File encoding
- Window splitting behavior

**Example settings:**

```vim
set number relativenumber
set tabstop=4 shiftwidth=4
set expandtab
set ignorecase smartcase
set hlsearch incsearch
```

### core/plugins.vim

Plugin declarations using vim-plug.

**Structure:**

```vim
call plug#begin('~/.vim/plugged')

" UI & Themes
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

" Completion & LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Navigation
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'

" ... more plugins

call plug#end()
```

**Categories:**

- UI/Themes
- Completion/LSP
- Navigation
- Language support
- Git integration
- Utilities

### core/mappings.vim

Global key mappings and leader key configuration.

**Contains:**

- Leader key definition (`let mapleader = " "`)
- File navigation mappings
- Window management
- Tab management
- Save/Quit shortcuts
- General utilities

## 🌐 Language Configurations

### langs/web.vim

Web development configuration (JavaScript, TypeScript, HTML, CSS).

**Features:**

- Syntax highlighting
- JSX/TSX support
- Neoformat formatting with Prettier
- ESLint integration
- React/Vue snippets
- Emmet shortcuts

**Key mappings:**

- `<leader>nd` - Next.js dev server
- `<leader>fmt` - format the current file
- `<leader>es` - ESLint fix

### langs/c.vim

C/C++ development configuration.

**Features:**

- Modern C++ syntax
- clangd LSP
- clang-format integration
- Compilation shortcuts
- GDB integration

**Key mappings:**

- `<leader>cc` - Compile C
- `<leader>cpp` - Compile C++
- `<leader>cr` - Run program
- `<leader>cd` - Debug with GDB

### langs/php.vim

PHP and Laravel development.

**Features:**

- PHP syntax
- Blade template support
- PHPActor LSP
- Composer integration
- Laravel Artisan shortcuts

**Key mappings:**

- `<leader>la` - Artisan command
- `<leader>ls` - Laravel serve
- `<leader>lm` - Run migrations

### langs/python.vim

Python development configuration.

**Features:**

- Python 3 syntax
- Pyright LSP
- Black formatter
- Flake8 linting
- Virtual environment support

**Key mappings:**

- `<leader>py` - Run Python
- `<leader>pf` - Format with Black
- `<leader>pt` - Run pytest

### langs/go.vim

Go development configuration.

**Features:**

- Go syntax
- gopls LSP
- gofmt/goimports
- Go modules support
- Testing integration

**Key mappings:**

- `<leader>gb` - Go build
- `<leader>gr` - Go run
- `<leader>gt` - Go test

### langs/bash.vim

Shell scripting configuration.

**Features:**

- Bash syntax
- ShellCheck linting
- shfmt formatting
- Execution shortcuts

**Key mappings:**

- `<leader>bx` - Make executable and run
- `<leader>br` - Run script
- `<leader>bc` - Syntax check

## 🎨 Framework Configurations

### frameworks/laravel.vim

Laravel-specific configuration and shortcuts.

**Features:**

- Blade syntax
- Artisan integration
- Route definitions
- Migration helpers
- Tinker support

### frameworks/nextjs.vim

Next.js specific configuration.

**Features:**

- Next.js commands
- Dev server integration
- Build shortcuts
- API route support

## 🛠️ Utility Configurations

### utils/termux.vim

Termux and mobile optimization.

**Features:**

- Touch-friendly mappings
- Alternative key bindings
- Storage access helpers
- Performance optimizations
- Mobile-specific UI tweaks

### utils/completion.vim

Coc.nvim completion configuration.

**Settings:**

- Completion sources
- Trigger behavior
- Popup menu settings
- Snippet configuration
- Language server configs

### utils/formatting.vim

Universal code formatting.

**Features:**

- Auto-format on save
- Per-filetype formatters
- Format command
- Formatter detection

**Supported formatters:**

- Neoformat with Prettier (JS/TS/HTML/CSS)
- Black (Python)
- clang-format (C/C++)
- gofmt (Go)
- shfmt (Bash)
- PHP CS Fixer (PHP)

### utils/ui.vim

Theme and UI configuration.

**Contains:**

- Color scheme selection
- Airline configuration
- Syntax highlighting
- Color adjustments
- Terminal colors

### utils/autopairs.vim

Auto-pairs plugin configuration.

**Features:**

- Auto-close brackets
- Auto-close quotes
- Smart deletion
- Fast wrap
- Multi-line support

## 🔧 Configuration Files

### coc-settings.json and coc-settings.minimal.json

Coc.nvim settings. The installer asks which one to use:

- **`coc-settings.minimal.json`** (installer default): suggestion tuning, diagnostics,
  file size limit, Prettier, and TypeScript completion. Lightweight, suited to phones.
- **`coc-settings.json`** (full): the same settings plus the long Tailwind/Headwind
  class lists.

The chosen file is copied to:

- `~/.vim/coc-settings.json` for Vim
- `~/.config/nvim/coc-settings.json` for Neovim (only if Neovim is installed)

An existing file at the destination is backed up first. Edit that copy to change
settings, or run `:CocConfig` inside the editor.

## 📦 The vimx Command

### /usr/bin/vimx

The `vimx` command is a copy of `vimx.sh`. The installer places it at `/usr/bin/vimx`
(or `$PREFIX/bin/vimx` on Termux) and uses `sudo` when needed.

**Usage:**

```bash
vimx install
vimx update
vimx add <plugin>
vimx doctor
vimx version
```

## 📚 Documentation

Documentation is published as a separate `docs/` archive and on the project site.
It is not loaded by the editor or the installer, so it can be updated without a
code release.

## 🔄 Loading Order

Configuration loads in this specific order:

1. **init.vim** - Entry point
2. **core/settings.vim** - Basic settings
3. **core/plugins.vim** - Plugin declarations
4. **utils/ui.vim** - Theme and UI
5. **utils/completion.vim** - Completion config
6. **utils/formatting.vim** - Formatting setup
7. **utils/autopairs.vim** - Auto-pairs config
8. **langs/\*.vim** - Language configs
9. **frameworks/\*.vim** - Framework configs
10. **utils/termux.vim** - Platform-specific (if on Termux)
11. **core/mappings.vim** - Key mappings
12. **Post-configuration hooks** - Final setup

## 📝 Adding New Configurations

### Adding New Language Support

1. Create file in `langs/` directory:

   ```bash
   touch ~/.config/vim/langs/rust.vim
   ```

2. Add language-specific settings:

   ```vim
   " langs/rust.vim
   " Rust development configuration

   " Syntax
   autocmd FileType rust se.config ...

   " Key mappings
   autocmd FileType rust nnoremap <leader>rb :!cargo build<CR>

   " LSP
   " Install: :CocInstall coc-rust-analyzer
   ```

3. Include in `init.vim`:
   ```vim
   " Load Rust configuration
   runtime! langs/rust.vim
   ```

### Adding New Framework

1. Create file in `frameworks/`:

   ```bash
   touch ~/.config/vim/frameworks/django.vim
   ```

2. Add framework config:

   ```vim
   " frameworks/django.vim
   " Django-specific configuration

   " Mappings
   nnoremap <leader>dr :!python manage.py runserver<CR>
   nnoremap <leader>dm :!python manage.py migrate<CR>
   ```

3. Include in `init.vim`:
   ```vim
   runtime! frameworks/django.vim
   ```

### Adding Custom Utilities

1. Create file in `utils/`:

   ```bash
   touch ~/.config/vim/utils/custom.vim
   ```

2. Add custom configuration:

   ```vim
   " utils/custom.vim
   " Personal customizations

   " Your custom settings here
   ```

3. Include in `init.vim`:
   ```vim
   runtime! utils/custom.vim
   ```

## 🎯 Best Practices

### Organization

- Keep related settings together
- Use comments to document sections
- Group similar configurations
- Maintain consistent naming

### Performance

- Use `autocmd` with `FileType` for language-specific settings
- Lazy load plugins when possible
- Avoid duplicate mappings
- Keep init.vim clean and modular

### Maintenance

- Document custom changes
- Regular backups before major changes
- Test changes in separate branch
- Use version control

## 🔍 Finding Configuration

### Locate Specific Setting

```vim
" Find where option is set
:verbose set option?

" Find mapping
:verbose map <leader>key

" Find plugin location
:echo g:plugs['plugin-name'].dir
```

### Browse Configuration

```bash
# List all config files
ls -R ~/.config/vim/

# Search for specific setting
grep -r "setting" ~/.config/vim/

# View specific file
vim ~/.config/vim/core/settings.vim
```

---

[← Home](/) | [Customization Guide →](customization.md)
