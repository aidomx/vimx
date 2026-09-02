---
outline: deep
---

# Backup & Restore

Protect your configuration with `vimx backup` and `vimx restore`.

## Creating a Backup

```bash
# Default backup location
vimx backup

# Specify output file
vimx backup ~/my-config-backup.tar.gz
```

The backup includes:
- `core/` — settings, plugins, mappings
- `langs/` — language configurations
- `utils/` — utility configurations
- `frameworks/` — framework configs
- `coc-settings.json` — LSP settings

## Restoring from Backup

```bash
vimx restore ~/my-config-backup.tar.gz
```

This:
1. Creates a safety backup of current config
2. Extracts the backup contents
3. Reloads the configuration

## What Gets Backed Up

| Item | Included |
| --- | --- |
| `core/settings.vim` | ✅ |
| `core/plugins.vim` | ✅ |
| `core/mappings.vim` | ✅ |
| `langs/*.vim` | ✅ |
| `utils/*.vim` | ✅ |
| `frameworks/*.vim` | ✅ |
| `coc-settings.json` | ✅ |
| `plugged/` (plugins) | ❌ |
| `undo/`, `swaps/` | ❌ |

## Automatic Backups

vimx creates automatic backups before:
- Resetting settings (`vimx reset`)
- Updating system (`vimx system-update`)
- Restoring from backup

Backups are stored in `~/.local/share/vimx/backups/`.

## Health Check

After restoring, verify everything works:

```bash
vimx doctor
vimx list
```

## Related

- [Installation](/installation) — Fresh install
- [Troubleshooting](/troubleshooting) — Fix common issues
