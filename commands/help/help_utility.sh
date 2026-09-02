#!/usr/bin/env bash

help_utility_commands() {
  echo -e "${WHITE}UTILITY COMMANDS:${NC}"
  echo -e "  ${GREEN}search${NC} <query>        Search plugins"
  echo -e "  ${GREEN}theme${NC}                 Theme manager"
  echo -e "  ${GREEN}install${NC}               Install/update vimx"
  echo -e "  ${GREEN}doctor${NC}                System health check"
  echo -e "  ${GREEN}backup${NC} [output]       Backup configuration"
  echo -e "  ${GREEN}restore${NC} <file>        Restore from backup"
  echo -e "  ${GREEN}version${NC}               Show version"
  echo -e "  ${GREEN}help${NC}                  Show this help"
}

help_utility_detailed() {
  case "$1" in
    backup)
      echo -e "${CYAN}vimx backup${NC} - Backup Vim configuration"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vimx backup [output-file]"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Creates a complete backup of your Vim configuration including:"
      echo "  • VIMX configuration files"
      echo "  • .vimrc"
      echo "  • Installed plugins"
      echo "  • Coc extensions and settings"
      echo "  • Neovim configuration (if exists)"
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vimx backup                          # Auto-generated filename"
      echo "  vimx backup ~/vim-backup.tar.gz      # Custom location"
      echo "  vimx backup ./backup-$(date +%Y%m%d).tar.gz"
      ;;

    restore)
      echo -e "${CYAN}vimx restore${NC} - Restore Vim configuration"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vimx restore <backup-file>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Restores Vim configuration from a previous backup."
      echo "  Creates a backup of current configuration before restoring."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vimx restore ~/vim-backup.tar.gz"
      echo "  vimx restore ./my-backup-20231201.tar.gz"
      echo ""
      echo -e "${WHITE}WARNING:${NC}"
      echo "  This will overwrite your current configuration!"
      ;;

    theme)
      echo -e "${CYAN}vimx theme${NC} - Theme manager"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vimx theme                    # Interactive theme selector"
      echo "  vimx theme list               # List installed themes"
      echo "  vimx theme current            # Show active theme"
      echo "  vimx theme set <name>         # Switch to a theme"
      echo "  vimx theme install <name>     # Install a theme plugin"
      echo "  vimx theme search <query>     # Search themes on GitHub"
      echo "  vimx theme available          # Show well-known themes"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Manage Vim colorscheme themes. Lists installed themes"
      echo "  from ~/.vim/plugged/ and lets you switch between them."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vimx theme                        # Pick from installed themes"
      echo "  vimx theme set dracula            # Switch to dracula"
      echo "  vimx theme install catppuccin     # Install catppuccin"
      echo "  vimx theme search gruvbox         # Search GitHub for gruvbox"
      echo "  vimx theme available              # List popular themes"
      ;;
  esac
}
