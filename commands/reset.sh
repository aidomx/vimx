#!/usr/bin/env bash

vimx_cmd_reset() {
  if [ $# -gt 0 ]; then
    case "$1" in
      "-h" | "--help")
        echo "Usage: vimx reset [option]"
        echo ""
        echo "Options:"
        echo "  settings    - Reset only settings to defaults"
        echo "  plugins     - Reset only plugins to defaults"
        echo "  mappings    - Reset only key mappings to defaults"
        echo "  all         - Reset everything (default)"
        echo ""
        echo "Examples:"
        echo "  vimx reset              # Reset everything"
        echo "  vimx reset settings     # Reset only settings"
        echo "  vimx reset plugins      # Reset only plugins"
        return 0
        ;;
    esac
  fi

  local reset_type=${1:-"all"}

  case "$reset_type" in
    "settings")
      reset_settings
      ;;
    "plugins")
      reset_plugins
      ;;
    "mappings")
      reset_mappings
      ;;
    "all")
      print_header "Resetting All Configuration"
      reset_settings
      reset_plugins
      reset_mappings
      print_success "Full configuration reset complete!"
      ;;
    *)
      print_error "Invalid reset type: $reset_type"
      echo "Run 'vimx reset --help' for usage information"
      return 1
      ;;
  esac
}

reset_settings() {
  print_info "Resetting settings to defaults..."

  if [ -f "${VIMX_SETTINGS_DEFAULT}" ]; then
    backup_config_file "${VIMX_SETTINGS_FILE}"
    cp "${VIMX_SETTINGS_DEFAULT}" "${VIMX_SETTINGS_FILE}"
    print_success "Settings reset to defaults"
  else
    print_warning "Default settings file not found, keeping current settings"
  fi
}

reset_plugins() {
  print_info "Resetting plugins to defaults..."

  if [ -f "${VIMX_PLUGINS_DEFAULT}" ]; then
    backup_config_file "${VIMX_PLUGINS_FILE}"
    cp "${VIMX_PLUGINS_DEFAULT}" "${VIMX_PLUGINS_FILE}"
    print_success "Plugins reset to defaults"
  else
    print_warning "Default plugins file not found, keeping current plugins"
  fi
}

reset_mappings() {
  print_info "Resetting key mappings to defaults..."

  if [ -f "${VIMX_MAPPINGS_DEFAULT}" ]; then
    backup_config_file "${VIMX_MAPPINGS_FILE}"
    cp "${VIMX_MAPPINGS_DEFAULT}" "${VIMX_MAPPINGS_FILE}"
    print_success "Key mappings reset to defaults"
  else
    print_warning "Default mappings file not found, keeping current mappings"
  fi
}
