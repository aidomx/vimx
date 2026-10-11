# vimx - Configuration Management Tool

vimx is a powerful command-line tool for managing your Vim configuration, plugins, and key mappings.

## 📚 Table of Contents

- [Installation](#installation)
- [Command Reference](#command-reference)
- [Usage Examples](#usage-examples)
- [Plugin Management](#plugin-management)
- [Key Mapping Management](#key-mapping-management)
- [System Maintenance](#system-maintenance)

## 🚀 Installation

vimx is automatically installed with the main configuration. To install manually:

```bash
# Copy to system PATH
sudo cp ~/.config/vim/vimx.sh /usr/bin/vimx
sudo chmod +x /usr/bin/vimx
```

## 📖 Command Reference

### Installation & System Management

| Command              | Description                      |
| -------------------- | -------------------------------- |
| `vimx install`       | First-time installation via vimx |
| `vimx update`        | Update all plugins               |
| `vimx system-update` | Update configuration system      |
| `vimx reinstall`     | Complete fresh reinstall         |
| `vimx doctor`        | System health check              |
| `vimx version`       | Show version information         |
| `vimx help`          | Show help                        |

### Plugin Management

| Command                     | Description                |
| --------------------------- | -------------------------- |
| `vimx add <plugin>`         | Add new plugin             |
| `vimx remove <plugin>`      | Remove plugin completely   |
| `vimx enable <plugin>`      | Enable disabled plugin     |
| `vimx disable <plugin>`     | Disable plugin             |
| `vimx disable slow_plugins` | Disable known slow plugins |
| `vimx list`                 | List all installed plugins |
| `vimx clean`                | Remove unused plugins      |

### Plugin Discovery

| Command               | Description              |
| --------------------- | ------------------------ |
| `vimx search <query>` | Search plugins on GitHub |
| `vimx info <plugin>`  | Show plugin information  |

### Key Mapping Management

| Command                        | Description                |
| ------------------------------ | -------------------------- |
| `vimx editmap`                 | Interactive mapping editor |
| `vimx editmap add <key> <cmd>` | Add new mapping            |
| `vimx editmap list`            | List all mappings          |

## 💡 Usage Examples

### Plugin Management

#### Adding Plugins

```bash
# Add a plugin from GitHub
vimx add tpope/vim-fugitive
vimx add preservim/nerdtree

# Add multiple plugins
vimx add tpope/vim-surround tpope/vim-repeat
```

#### Removing Plugins

```bash
# Remove a single plugin
vimx remove coc.nvim

# Remove multiple plugins
vimx remove vim-airline vim-airline-themes
```

#### Enabling/Disabling Plugins

```bash
# Disable a plugin temporarily
vimx disable copilot.vim

# Enable it back
vimx enable copilot.vim

# Disable all slow plugins
vimx disable slow_plugins
```

#### Listing Plugins

```bash
# List all installed plugins
vimx list

# List all plugins
vimx list
```

### Plugin Discovery

#### Searching for Plugins

```bash
# Search for fuzzy finder plugins
vimx search fuzzy finder

# Search for syntax highlighting
vimx search "syntax highlight"

# Search for specific language support
vimx search typescript
```

#### Getting Plugin Information

```bash
# Get detailed information about a plugin
vimx info nerdtree
vimx info coc.nvim

# Shows: description, stars, last update, homepage
```

### System Maintenance

#### Update Everything

```bash
# Update all plugins
vimx update

# Update configuration system
vimx system-update

# Update both
vimx update && vimx system-update
```

#### Health Check

```bash
# Run comprehensive health check
vimx doctor

# Checks:
# - Vim/Neovim installation
# - Required packages
# - Plugin status
# - Configuration integrity
# - Language servers
```

#### Clean Up

```bash
# Remove unused plugins
vimx clean

# This will:
# - Remove plugins not in configuration
# - Clean plugin cache
# - Remove orphaned files
```

#### Complete Reinstall

```bash
# Fresh reinstall of everything
vimx reinstall

# Warning: This will:
# - Backup current configuration
# - Remove all plugins
# - Reinstall from scratch
# - Restore custom settings
```

### Key Mapping Management

#### Interactive Mapping Editor

```bash
# Open interactive editor
vimx editmap

# Features:
# - Browse all mappings
# - Add/edit/delete mappings
# - Test mappings
# - Export/import mappings
```

#### Add Mappings

```bash
# Add a single mapping
vimx editmap add '<leader>ff' ':Files<CR>'

# Add with description
vimx editmap add '<leader>gg' ':GFiles<CR>' 'Search git files'

# Add mapping to specific file
vimx editmap add '<leader>py' ':!python %<CR>' --file langs/python.vim
```

#### List Mappings

```bash
# List all mappings
vimx editmap list

# List mappings for specific mode
vimx editmap list --mode normal
vimx editmap list --mode insert

# List mappings with filter
vimx editmap list --filter leader
```

## 🔧 Advanced Usage

### Configuration Files

vimx manages these configuration files:

```
~/.config/vim/
├── core/
│   ├── plugins.vim      # Plugin declarations
│   └── mappings.vim     # Key mappings
├── langs/               # Language-specific configs
└── utils/               # Utility configs
```

### Custom Plugin Sources

> **Note:** Custom plugin sources and local plugins are not yet supported. Use `vimx add user/repo` format.

```bash
# Add plugin from GitHub
vimx add tpope/vim-fugitive
```

### Backup and Restore

```bash
# Backup current configuration
vimx backup ~/vim-backup.tar.gz

# Restore from backup
vimx restore ~/vim-backup.tar.gz
```

### Plugin Profiles

> **Note:** Plugin profiles are planned for a future release.

```bash
# Planned commands
vimx profile create minimal --plugins "nerdtree,fzf"
vimx profile switch minimal
```

## 🐛 Troubleshooting

### Common Issues

#### vimx command not found

```bash
# Add to PATH
echo 'export PATH="$HOME/.config/vim:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Permission denied

```bash
# Fix permissions
chmod +x ~/.config/vim/vimx.sh
```

#### Plugin installation fails

```bash
# Check network
vimx doctor

# Retry installation
vimx update --force
```

### Debug Mode

```bash
# Run with debug output
vimx --debug update

# Verbose mode
vimx -v doctor
```

## 📊 Status Codes

vimx uses standard exit codes:

- `0` - Success
- `1` - General error
- `2` - Invalid arguments
- `3` - Plugin not found
- `4` - Network error
- `5` - Permission denied

## 🔌 Plugin Manager Support

vimx supports multiple plugin managers:

### vim-plug (Default)

```bash
# Automatically detected and used
vimx add tpope/vim-fugitive
```

### packer.nvim (Neovim)

```bash
# Use with packer
vimx --manager packer add tpope/vim-fugitive
```

### lazy.nvim (Neovim)

```bash
# Use with lazy
vimx --manager lazy add tpope/vim-fugitive
```

## 🎯 Best Practices

1. **Regular Updates**: Run `vimx update` weekly
2. **Health Checks**: Run `vimx doctor` after major changes
3. **Clean Up**: Run `vimx clean` monthly
4. **Backups**: Create backups before major changes
5. **Test New Plugins**: Disable slow plugins if needed

## 📝 Configuration

vimx can be configured via `~/.config/vim/config.yaml`:

```yaml
# Default plugin manager
plugin_manager: vim-plug

# Auto-update plugins
auto_update: true

# Check frequency (days)
check_frequency: 7

# Backup location
backup_dir: ~/.local/share/vimx/backups

# Enable debug mode
debug: false
```

## 🔜 Future Features

Planned features for vimx:

- [ ] Plugin dependency management
- [ ] Automatic performance profiling
- [ ] Cloud backup integration
- [ ] Plugin recommendations
- [ ] Configuration synchronization
- [ ] Web interface

---

[← Home](/)
