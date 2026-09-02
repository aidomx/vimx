#!/usr/bin/env bash

help_settings_commands() {
  echo -e "${WHITE}SETTINGS COMMANDS:${NC}"
  echo -e "  ${GREEN}set${NC} <setting> [value] Configure editor settings"
  echo -e "  ${GREEN}reset${NC} [type]          Reset configuration to defaults"
}

help_settings_detailed() {
  case "$1" in
  set)
    echo -e "${CYAN}vimx set${NC} - Configure editor settings"
    echo ""
    echo -e "${WHITE}USAGE:${NC}"
    echo "  vimx set <setting> [value]"
    echo ""
    echo -e "${WHITE}DESCRIPTION:${NC}"
    echo "  Configure Vim settings without editing config files manually."
    echo "  Changes are applied to core/settings.vim"
    echo ""
    echo -e "${WHITE}EXAMPLES:${NC}"
    echo "  vimx set number                  # Enable line numbers"
    echo "  vimx set tabstop 4              # Set tab to 4 spaces"
    echo "  vimx set syntax on              # Enable syntax highlighting"
    echo "  vimx set list                   # Show available settings"
    echo ""
    echo -e "${WHITE}SUPPORTED SETTINGS:${NC}"
    echo "  • number|nonumber              - Line numbers"
    echo "  • tabstop <n>                  - Spaces per tab"
    echo "  • shiftwidth <n>               - Indent size"
    echo "  • expandtab|noexpandtab        - Use spaces/tabs"
    echo "  • syntax|nosyntax              - Syntax highlighting"
    echo "  • cursorline|nocursorline      - Current line highlight"
    ;;

  reset)
    echo -e "${CYAN}vimx reset${NC} - Reset configuration to defaults"
    echo ""
    echo -e "${WHITE}USAGE:${NC}"
    echo "  vimx reset [settings|plugins|mappings|all]"
    echo ""
    echo -e "${WHITE}DESCRIPTION:${NC}"
    echo "  Reset configuration files to their default state."
    echo "  Creates backups before resetting."
    echo ""
    echo -e "${WHITE}EXAMPLES:${NC}"
    echo "  vimx reset                      # Reset everything"
    echo "  vimx reset settings            # Reset only settings"
    echo "  vimx reset plugins             # Reset only plugins"
    echo "  vimx reset mappings            # Reset only key mappings"
    echo ""
    echo -e "${WHITE}NOTE:${NC}"
    echo "  Backups are stored in ~/.local/share/vimx/backups/"
    ;;
  esac
}
