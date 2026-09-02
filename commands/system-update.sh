#!/usr/bin/env bash

vimx_cmd_system_update() {
  print_header "Updating Vim Configuration System"

  if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Vim configuration not found. Run 'vimx install' first."
    return 1
  fi

  # Update the configuration repository
  cd "$INSTALL_DIR"

  print_info "Pulling latest changes from repository..."
  if git pull --rebase origin main; then
    print_success "Configuration updated successfully"

    # Update vimx tool jika ada perubahan
    if [ -f "$INSTALL_DIR/vimx.sh" ]; then
      install_vimx
    fi

    print_success "System update completed!"
    echo ""
    print_info "You may want to also update your plugins: ${CYAN}vimx update${NC}"
  else
    print_error "Failed to update configuration"
    return 1
  fi
}
