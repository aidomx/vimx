---
outline: deep
---

# Troubleshooting Guide

Solutions to common problems and issues.

## 📚 Table of Contents

- [Installation Issues](#installation-issues)
- [Plugin Issues](#plugin-issues)
- [Coc.nvim Issues](#cocnvim-issues)
- [Performance Issues](#performance-issues)
- [Formatting Issues](#formatting-issues)
- [Termux-Specific Issues](#termux-specific-issues)
- [LSP Issues](#lsp-issues)
- [General Issues](#general-issues)

## 🔧 Installation Issues

### Plugins Not Loading

**Symptoms:** Plugins don't appear to work after installation

**Solutions:**

```vim
" 1. Reinstall plugins
:PlugInstall

" 2. Update plugins
:PlugUpdate

" 3. Clean unused plugins
:PlugClean

" 4. Reload configuration
:source ~/.vimrc
```

```bash
# Or using vimx
vimx update
vimx clean
vimx doctor
```

### vim-plug Not Found

**Symptoms:** Error: `Cannot find vim-plug`

**Solution:**

```bash
# Reinstall vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Then in Vim
:PlugInstall
```

### Permission Denied Errors

**Symptoms:** Permission errors when installing

**Solution:**

```bash
# Fix permissions
chmod -R u+w ~/.vim
chmod -R u+w ~/.config/vim
chmod +x ~/.config/vim/vimx.sh

# For system-wide vimx
sudo chmod +x /usr/bin/vimx
```

### Git Clone Failed

**Symptoms:** Unable to clone repository

**Solutions:**

```bash
# 1. Check internet connection
ping github.com

# 2. Use HTTPS instead of SSH
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://".insteadOf git://

# 3. Clone manually
git clone https://github.com/aidomx/vimx.git ~/.config/vim
```

## 🔌 Plugin Issues

### Plugin Installed But Not Working

**Diagnostic Steps:**

```vim
" 1. Check if plugin is loaded
:scriptnames

" 2. Check for errors
:messages

" 3. Check plugin status
:PlugStatus
```

**Solutions:**

```bash
# Update the problematic plugin
vimx update <plugin-name>

# Or disable temporarily
vimx disable <plugin-name>
```

### NERDTree Not Opening

**Symptoms:** `tt` doesn't open file explorer

**Solutions:**

```vim
" 1. Check if NERDTree is installed
:PlugStatus

" 2. Try manual command
:NERDTreeToggle

" 3. Check for conflicts
:verbose map tt
```

> **Note:** The `tt` mapping is for NERDTreeToggle, `ff` for NERDTreeFind, `nf` for NERDTreeFocus.

```bash
# Reinstall NERDTree
vimx remove nerdtree
vimx add preservim/nerdtree
```

### FZF Not Working

**Symptoms:** Fuzzy finder commands fail

**Solutions:**

```bash
# 1. Install fzf binary
# Termux
pkg install fzf

# Arch
sudo pacman -S fzf

# Ubuntu
sudo apt install fzf

# 2. Check installation
which fzf

# 3. Reinstall fzf.vim
vimx update fzf.vim
```

### Copilot Not Suggesting

**Symptoms:** No AI suggestions appear

**Solutions:**

```vim
" 1. Check Copilot status
:Copilot status

" 2. Setup Copilot
:Copilot setup

" 3. Enable Copilot
:Copilot enable

" 4. Check authentication
:Copilot auth
```

## 🎯 Coc.nvim Issues

### Coc Not Starting

**Symptoms:** No autocompletion, LSP features not working

**Solutions:**

```vim
" 1. Check Coc status
:CocInfo

" 2. Restart Coc
:CocRestart

" 3. Check Node.js
:!node --version

" 4. Rebuild Coc
:CocCommand coc.build
```

```bash
# Install/update Node.js
# Termux
pkg install nodejs

# Arch
sudo pacman -S nodejs npm

# Check version (needs 14+)
node --version
```

### Coc Extensions Not Installing

**Symptoms:** `:CocInstall` fails

**Solutions:**

```vim
" 1. Check Coc output
:CocOpenLog

" 2. Update Coc
:CocUpdate

" 3. Clear Coc cache
:CocCommand workspace.clearWatchman
```

```bash
# Clear npm cache
npm cache clean --force

# Reinstall coc.nvim
cd ~/.vim/plugged/coc.nvim
npm install
```

### Language Server Not Working

**Symptoms:** No completion for specific language

**Solutions:**

```vim
" 1. Check if extension is installed
:CocList extensions

" 2. Install language server
:CocInstall coc-tsserver  " for TypeScript
:CocInstall coc-pyright   " for Python
:CocInstall coc-clangd    " for C/C++

" 3. Check LSP status
:CocCommand workspace.showOutput

" 4. Configure LSP
:CocConfig
```

### Coc Settings Not Applied

**Symptoms:** Custom Coc settings don't work

**Solutions:**

```vim
" 1. Check coc-settings.json location
:echo coc#util#get_config_home()

" 2. Edit settings
:CocConfig

" 3. Validate JSON
:CocCommand workspace.validate
```

## ⚡ Performance Issues

### Vim Starts Slowly

**Symptoms:** Long startup time

**Diagnostic:**

```bash
# Profile startup time
vim --startuptime startup.log
less startup.log
```

**Solutions:**

```bash
# 1. Disable slow plugins
vimx disable slow_plugins

# 2. Use lazy loading
# Edit ~/.config/vim/core/plugins.vim
# Change: Plug 'plugin/name'
# To: Plug 'plugin/name', { 'on': 'Command' }

# 3. Reduce number of plugins
vimx list
vimx remove unused-plugin
```

### Vim Lags When Typing

**Symptoms:** Delay when typing or moving cursor

**Solutions:**

```vim
" 1. Disable Coc temporarily
:CocDisable

" 2. Disable syntax highlighting
:syntax off

" 3. Check what's running
:profile start profile.log
:profile func *
:profile file *
" Do some actions
:profile pause
:noautocmd qall!
```

```bash
# Optimize configuration
vimx doctor

# Disable heavy plugins
vimx disable copilot.vim
vimx disable coc.nvim
```

### High Memory Usage

**Solutions:**

```vim
" 1. Limit Coc memory
" In :CocConfig
{
  "workspace.maxFileSize": 2,
  "suggest.maxCompleteItemCount": 50
}

" 2. Disable unused language servers
:CocList extensions
" Select and disable unused ones
```

## 🎨 Formatting Issues

### Formatter Not Found

**Symptoms:** `:Format`, `:Neoformat`, or `<leader>fmt` doesn't work

**Solutions:**

```bash
# Check if formatter is installed
which prettier
which black
which clang-format
which shfmt

# Install missing formatters
# Prettier for Neoformat (JS/TS/HTML/CSS)
# Prefer a project-local installation:
npm install --save-dev prettier

# Or install globally:
npm install -g prettier

# Black (Python)
pip install black

# clang-format (C/C++)
# Termux
pkg install clang

# Arch
sudo pacman -S clang

# shfmt (Bash)
pkg install shfmt  # Termux
sudo pacman -S shfmt  # Arch
```

### Neoformat: no change necessary

This message means Prettier exited successfully but produced the same content as
the current buffer. It is informational, not an error. If the output is empty or
formatting does not happen, check that Prettier is installed and run Neoformat
with verbose logging:

```vim
:let g:neoformat_verbose = 1
:Neoformat
:messages
```

For project-local Prettier, install it from the project root:

```bash
npm install --save-dev prettier
```

### Wrong Format Applied

**Symptoms:** File formatted incorrectly

**Solutions:**

```vim
" 1. Check filetype
:set filetype?

" 2. Manually set filetype
:set filetype=javascript

" 3. Configure formatter for filetype
" In ~/.config/vim/utils/formatting.vim
```

### Format On Save Not Working

**Symptoms:** Files don't auto-format on save

**Solutions:**

```vim
" 1. Check the Neoformat autocommands
:autocmd BufWritePre

" 2. Check the active filetype
:set filetype?

" 3. Try formatting manually
:Neoformat
```

Save-time formatting is set by filetype (see `utils/formatting.vim`):

- **On save:** JavaScript, TypeScript, HTML, CSS, JSON, YAML (Neoformat with Prettier), shell (`shfmt`), Python (`black` or `autopep8`), Go (`gofmt`), PHP (`php-cs-fixer`), and C/C++ through ALE (`clang-format`).
- **Not on save:** Markdown. Format it manually with `<leader>fmt`.

Coc format-on-save stays disabled (`"coc.preferences.formatOnSave": false`) so only one formatter runs.

## 🔧 Installer and vimx Doctor

### The Installer Stops Right After a Question

**Symptoms:** The installer prints a prompt (for example `Install optional tools? [y/N]:`), you answer, and nothing else appears.

**Cause:** The installer was started through a pipe, and an older version read its answers from the pipe. The current version reads answers from `/dev/tty` and uses the default when there is no answer.

**Solutions:**

```bash
# 1. Make sure the code you run is current. curl installs the main branch.
#    Run the installer from a local copy instead:
cd ~/vimx-src && bash install.sh

# 2. Clean up the partial install, then try again
rm -rf ~/.config/vim
```

### Optional Tool Install Looks Stuck

**Symptoms:** A package shows a spinner for a long time.

**Solutions:**

- Each package shows a spinner while it runs. A slow mirror or a large download can take minutes.
- A package that fails shows the last three lines of its log, then the installer moves on.
- For `apt` and `pacman`, the installer asks for your sudo password before it starts installing, not during.
- Check the package name for your distribution. For example, `shellcheck` and `shfmt` names differ between some distributions.

### Syntax Check Reports "has issues" for a Valid File

**Symptoms:** `vimx doctor` marks `plugins.vim`, `settings.vim`, or `mappings.vim` with `✗`.

**Cause:** Only a real syntax error counts as a failure. Missing functions, commands, or colorschemes (`E117`, `E492`, `E185`) mean a plugin is not loaded yet, and the doctor reports those as skipped.

**Solutions:**

1. Read the grey line below the `✗`. It shows the exact Vim error.
2. Run the file directly to see the error with its line number:

   ```bash
   vim -Nu NONE -es -c 'source ~/.config/vim/core/mappings.vim' -c 'qa!'
   ```

### Doctor Stops in the Performance Section

**Cause:** Older versions started Vim as an interactive editor to measure startup. Vim could wait for a key press. The current version starts Vim with no terminal and `-c 'qa!'`, so it cannot wait for input.

**Solution:** Update to the current version, then run `vimx doctor` again.

## 📱 Termux-Specific Issues

### Keyboard Mappings Not Working

**Symptoms:** Key combinations don't trigger actions

**Solutions:**

1. **Use Alternative Mappings:**
   - Replace `Alt` with `Ctrl`
   - Use `:` commands instead

2. **Install Hacker's Keyboard:**
   - Download from F-Droid or Play Store
   - Provides more keys

3. **Use Extra Keys in Termux:**
   ```bash
   # ~/.termux/termux.properties
   extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
   ```

### Colors Not Displaying Correctly

**Symptoms:** Wrong colors or no colors

**Solutions:**

```bash
# 1. Check terminal emulator
echo $TERM

# 2. Set proper term
export TERM=xterm-256color

# Add to ~/.bashrc
echo 'export TERM=xterm-256color' >> ~/.bashrc

# 3. In Vim
:set termguicolors
```

### Touch Not Working

**Symptoms:** Can't use touch to position cursor

**Solutions:**

```vim
" Enable mouse support
:set mouse=a

" Add to vimrc permanently
echo 'set mouse=a' >> ~/.vimrc
```

### Storage Permission Issues

**Symptoms:** Can't access files in storage

**Solutions:**

```bash
# Grant storage permission
termux-setup-storage

# Access files in ~/storage/
cd ~/storage/shared
```

## 🔍 LSP Issues

### Go to Definition Not Working

**Symptoms:** `gd` doesn't jump to definition

**Solutions:**

```vim
" 1. Check if LSP is running
:CocInfo

" 2. Check language server
:CocCommand workspace.showOutput

" 3. Restart LSP
:CocRestart

" 4. Check if file is in project
" LSP needs compile_commands.json or similar
```

### No Completion Suggestions

**Symptoms:** No autocompletion popup

**Solutions:**

```vim
" 1. Trigger manually
<C-Space>

" 2. Check Coc sources
:CocList sources

" 3. Check if LSP is attached
:CocCommand document.checkHealth

" 4. Install language server
:CocInstall coc-tsserver  " example
```

### Diagnostics Not Showing

**Symptoms:** No error/warning highlights

**Solutions:**

```vim
" 1. Check diagnostic info
:CocDiagnostics

" 2. Enable diagnostics
:CocCommand document.toggleInlayHint

" 3. Check Coc config
:CocConfig
" Add:
{
  "diagnostic.enable": true,
  "diagnostic.level": "warning"
}

" 4. Restart Coc
:CocRestart
```

## 🐛 General Issues

### Vim Crashes

**Symptoms:** Vim closes unexpectedly

**Solutions:**

```bash
# 1. Check logs
tail -f ~/.vim/log

# 2. Start with minimal config
vim -u NONE file.txt

# 3. Disable plugins one by one
vimx disable <plugin-name>

# 4. Check for updates
vimx update
vimx system-update
```

### Configuration Not Loading

**Symptoms:** Changes in config files not applied

**Solutions:**

```bash
# 1. Check vimrc is sourced
vim --version | grep vimrc

# 2. Verify config location
ls -la ~/.vimrc
ls -la ~/.config/vim/init.vim

# 3. Check for syntax errors
vim -u ~/.vimrc -c 'source %' -c 'qa!'

# 4. Reload configuration
# In Vim:
:source ~/.vimrc
```

### File Type Not Detected

**Symptoms:** Wrong syntax highlighting or no LSP

**Solutions:**

```vim
" 1. Check current filetype
:set filetype?

" 2. Manually set filetype
:set filetype=javascript
:set filetype=python
:set filetype=cpp

" 3. Check filetype detection
:filetype

" 4. Enable filetype detection
:filetype on
:filetype plugin indent on
```

### Search Not Working

**Symptoms:** `/` search doesn't highlight matches

**Solutions:**

```vim
" 1. Enable highlight search
:set hlsearch

" 2. Enable incremental search
:set incsearch

" 3. Clear old highlights
:noh

" 4. Check if search is working
/test
```

### Clipboard Not Working

**Symptoms:** Can't copy to system clipboard

**Solutions:**

```bash
# 1. Check if vim has clipboard support
vim --version | grep clipboard

# 2. Install vim with clipboard
# Termux
pkg install vim-python

# Arch
sudo pacman -S gvim  # has +clipboard

# Ubuntu
sudo apt install vim-gtk3
```

```vim
" 3. Use clipboard register
"+y  " Copy to clipboard
"+p  " Paste from clipboard

" 4. Set clipboard option
:set clipboard=unnamedplus
```

### Undo History Lost

**Symptoms:** Can't undo after reopening file

**Solutions:**

```vim
" 1. Enable persistent undo
:set undofile

" 2. Set undo directory
:set undodir=~/.vim/undo

" 3. Create undo directory
:!mkdir -p ~/.vim/undo

" 4. Add to vimrc permanently
echo 'set undofile' >> ~/.vimrc
echo 'set undodir=~/.vim/undo' >> ~/.vimrc
```

## 🔧 Debug Commands

### Useful Diagnostic Commands

```vim
" Check loaded scripts
:scriptnames

" Check all messages
:messages

" Check runtime path
:set runtimepath?

" Check specific option
:set option?
:verbose set option?

" Check mappings
:map
:nmap  " Normal mode
:imap  " Insert mode
:vmap  " Visual mode

" Check plugin status
:PlugStatus

" Check Coc status
:CocInfo
:CocList extensions
:CocOpenLog

" Profile performance
:profile start profile.log
:profile func *
:profile file *
" Do actions
:profile pause
:quit
```

### Health Check

```bash
# Using vimx
vimx doctor

# Output includes:
# - System information
# - Vim/Neovim version
# - Required packages
# - Plugin status
# - LSP status
# - Performance metrics
```

### Manual Health Check

```vim
" In Neovim
:checkhealth

" Check specific component
:checkhealth provider
:checkhealth nvim
```

## 📝 Logging

### Enable Debug Logging

```vim
" 1. Enable Coc logging
:CocCommand workspace.showOutput

" 2. Set log level
:CocConfig
{
  "coc.preferences.extensionUpdateCheck": "daily",
  "suggest.timeout": 500,
  "diagnostic.refreshOnInsertMode": true,
  "diagnostic.level": "information"
}

" 3. View logs
:CocOpenLog
```

### Vim Debug Mode

```bash
# Start vim in debug mode
vim -D file.txt

# Verbose mode
vim -V9logfile.txt file.txt

# Check specific command
vim -c 'verbose command' -c 'qa!'
```

## 🔄 Reset Configuration

### Complete Reset

```bash
# 1. Backup current config
cp -r ~/.config/vim ~/.config/vim.backup
cp ~/.vimrc ~/.vimrc.backup

# 2. Remove configuration
rm -rf ~/.config/vim
rm -rf ~/.vim/plugged
rm ~/.vimrc

# 3. Reinstall
curl -fsSL https://raw.githubusercontent.com/aidomx/vimx/main/install.sh | bash
```

### Reset Specific Component

```bash
# Reset plugins
rm -rf ~/.vim/plugged
vim -c 'PlugInstall' -c 'qa!'

# Reset Coc
rm -rf ~/.config/coc
vim -c 'CocInstall coc-tsserver coc-json' -c 'qa!'

# Reset vimx
vimx reinstall
```

## 🆘 Getting Help

### Documentation

```vim
" Vim help
:help
:help mappings
:help options

" Plugin help
:help nerdtree
:help fzf
:help coc-nvim

" Search help
:helpgrep search-term
```

### Community Support

- **GitHub Issues**: [Report bugs](https://github.com/aidomx/vimx/issues)
- **Discussions**: [Ask questions](https://github.com/aidomx/vimx/discussions)
- **Stack Overflow**: Tag `vim` or `neovim`
- **Reddit**: r/vim, r/neovim

### Collect Debug Information

When reporting issues, include:

```bash
# 1. System info
uname -a
vim --version

# 2. vimx doctor output
vimx doctor > debug-info.txt

# 3. Plugin status
vim -c 'PlugStatus' -c 'wq plugins.txt'

# 4. Coc info
vim -c 'CocInfo' -c 'wq coc-info.txt'

# 5. Error messages
vim -c 'messages' -c 'wq messages.txt'
```

## 📋 Checklist for Troubleshooting

Before asking for help, try:

- [ ] Restart Vim
- [ ] Run `:PlugUpdate`
- [ ] Run `vimx doctor`
- [ ] Check error messages (`:messages`)
- [ ] Try with minimal config (`vim -u NONE`)
- [ ] Update system packages
- [ ] Check documentation
- [ ] Search existing issues
- [ ] Clear cache (`vimx clean`)

## 🔍 Common Error Messages

### "E117: Unknown function"

**Cause:** Function not loaded or plugin missing

**Solution:**

```vim
:PlugInstall
:source ~/.vimrc
```

### "E185: Cannot find color scheme"

**Cause:** Theme plugin not installed

**Solution:**

```bash
vimx add morhetz/gruvbox
vim -c 'PlugInstall' -c 'qa!'
```

### "node not found"

**Cause:** Node.js not installed or not in PATH

**Solution:**

```bash
# Install Node.js
pkg install nodejs  # Termux
sudo pacman -S nodejs  # Arch

# Add to PATH
which node
echo 'export PATH="/path/to/node:$PATH"' >> ~/.bashrc
```

### "coc.nvim not ready"

**Cause:** Coc.nvim building or not installed properly

**Solution:**

```vim
:CocInfo
:CocRestart

" Or rebuild
cd ~/.vim/plugged/coc.nvim
npm install
```

### "Permission denied"

**Cause:** File/directory permission issues

**Solution:**

```bash
chmod -R u+w ~/.vim
chmod -R u+w ~/.config/vim
sudo chown -R $USER:$USER ~/.vim
```

## 💡 Performance Optimization Tips

If experiencing slowness:

1. **Profile startup:**

   ```bash
   vim --startuptime startup.log
   grep -v "0\.0" startup.log | sort -k2 -n
   ```

2. **Disable unused plugins:**

   ```bash
   vimx disable slow_plugins
   ```

3. **Reduce Coc completion:**

   ```vim
   :CocConfig
   {
     "suggest.maxCompleteItemCount": 20,
     "suggest.timeout": 500
   }
   ```

4. **Lazy load plugins:**

   ```vim
   " In core/plugins.vim
   Plug 'plugin/name', { 'on': 'CommandName' }
   ```

5. **Reduce syntax features:**
   ```vim
   :syntax sync minlines=256
   ```

## 🎯 Quick Fixes

| Problem            | Quick Fix                     |
| ------------------ | ----------------------------- |
| Slow startup       | `vimx disable slow_plugins`   |
| No completion      | `:CocRestart`                 |
| Wrong colors       | `:set termguicolors`          |
| Plugin not working | `:PlugUpdate`                 |
| Config not loading | `:source ~/.vimrc`            |
| Coc not working    | `:CocInfo` then `:CocRestart` |
| Formatting fails   | Check formatter installed     |
| LSP not working    | `:CocInstall coc-<language>`  |

---

[← Home](/) | [Performance Guide →](performance.md)
