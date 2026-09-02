#!/usr/bin/env bash

vimx_cmd_install() {
  # Hanya untuk first-time installation via vimx command
  if [ -d "$INSTALL_DIR" ]; then
    print_error "Vim configuration already installed at: $INSTALL_DIR"
    echo ""
    echo -e "It looks like you already have vimx installed!"
    echo ""
    echo -e "If you want to:"
    echo -e "  ${CYAN}• Update plugins:${NC}        vimx update"
    echo -e "  ${CYAN}• Reinstall completely:${NC}  vimx reinstall"
    echo -e "  ${CYAN}• Update system:${NC}         vimx system-update"
    echo -e "  ${CYAN}• Check system health:${NC}   vimx doctor"
    echo ""
    echo -e "For fresh installation on a new system, use:"
    echo -e "  ${CYAN}curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash${NC}"
    echo ""
    return 1
  fi

  # Jika sampai sini, berarti first-time installation via vimx command
  # (jarang terjadi, tapi handle untuk completeness)
  print_header "First-time Vim Configuration Installation via vimx"

  # Pre-installation checks
  check_dependencies

  # Installation steps
  clone_repository
  setup_vimrc
  install_plugin_manager
  install_plugins
  install_vimx

  # Optional setup
  setup_optional_tools

  # Completion
  show_next_steps
}

check_existing_installation() {
  if [ -d "$INSTALL_DIR" ]; then
    echo ""
    print_warning "Existing installation found at: $INSTALL_DIR"
    echo ""
    echo -e "Choose an option:"
    echo -e "  ${GREEN}1${NC}) Backup and reinstall (recommended)"
    echo -e "  ${YELLOW}2${NC}) Update existing installation"
    echo -e "  ${RED}3${NC}) Cancel installation"
    echo ""

    read -p "Enter your choice [1-3]: " choice

    case $choice in
    1)
      backup_existing
      return 0
      ;;
    2)
      update_existing
      exit 0
      ;;
    3)
      print_info "Installation cancelled"
      exit 0
      ;;
    *)
      print_error "Invalid choice"
      exit 1
      ;;
    esac
  fi
}

copy_plugins_tmp() {
  cat >"$HOME/.vimrc" <<EOF
  $(cat ~/.config/vim/core/plugins.vim)
EOF
}

install_plugins() {
  print_header "Installing Plugins"

  print_info "This may take a few minutes..."
  echo ""
  cleanup_plugins

  # Install berdasarkan plugin manager
  if [ -f "${HOME}/.vim/autoload/plug.vim" ] || [ -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    print_info "Installing plugins via vim-plug..."
    copy_plugins_tmp
    vim -N -u "$HOME/.vimrc" -c 'PlugInstall --sync' -c 'qa!' >/dev/null 2>&1 &
    local vim_pid=$!
    progress "percent" $vim_pid "${CYAN}[PROGRESS]${NC} vim-plug plugins"
    wait $vim_pid
    local exit_code=$?

    # Verifikasi instalasi - cek apakah ada plugin yang terinstall
    if [ $exit_code -eq 0 ]; then
      local plugin_count=$(find "${HOME}/.vim/plugged" -maxdepth 1 -type d 2>/dev/null | wc -l)
      plugin_count=$((plugin_count - 1))

      if [ $plugin_count -gt 0 ]; then
        print_success "Plugins installed via vim-plug (${plugin_count} plugins)"
        create_clean_vimrc
      else
        print_warning "No plugins found. Check your plugins.vim configuration"
      fi
    else
      print_warning "Plugin installation may have issues. Run manually: vim +PlugInstall"
    fi

  elif [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    print_info "Installing plugins via packer.nvim..."

    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' >/dev/null 2>&1 &
    local nvim_pid=$!

    progress "percent" $nvim_pid "Installing packer.nvim plugins"
    wait $nvim_pid
    print_success "Plugins installed via packer.nvim"

  elif [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    print_info "Installing plugins via lazy.nvim..."

    nvim --headless -c 'Lazy sync' -c 'qa!' >/dev/null 2>&1 &
    local lazy_pid=$!

    progress "percent" $lazy_pid "Installing lazy.nvim plugins"
    wait $lazy_pid
    print_success "Plugins installed via lazy.nvim"

  else
    print_warning "No plugin manager detected, skipping plugin installation"
  fi

  echo ""
}

install_vimx() {
  print_header "Installing vimx Tool"

  local vimx_source="${INSTALL_DIR}/vimx.sh"

  if [ ! -f "$vimx_source" ]; then
    print_error "vimx.sh not found in repository"
    return 1
  fi

  local OS="$(uname -o)"

  case "${OS}" in
  "Android")
    VIMX_BIN="$PREFIX/bin/vimx"
    print_info "Installing vimx to ${VIMX_BIN}..."

    if [ -w "$PREFIX/bin" ]; then
      cp "$vimx_source" "$VIMX_BIN"
      chmod +x "$VIMX_BIN"
    fi

    ;;
  "GNU/Linux")
    print_info "Installing vimx to ${VIMX_BIN}..."

    # Check if we can write to /usr/bin
    if [ -w "/usr/bin" ]; then
      cp "$vimx_source" "$VIMX_BIN"
      chmod +x "$VIMX_BIN"
    else
      # Need sudo
      if command -v sudo &>/dev/null; then
        sudo cp "$vimx_source" "$VIMX_BIN"
        sudo chmod +x "$VIMX_BIN"
      else
        print_warning "Cannot install to /usr/bin (no sudo available)"
        print_info "You can manually copy: cp $vimx_source $VIMX_BIN"
        return 1
      fi
    fi
    ;;
  esac

  # Verify installation
  if command -v vimx >/dev/null 2>&1; then
    cp -f "$INSTALL_DIR/coc-settings.json" "$HOME/.vim/"
    print_success "vimx installed successfully"
    vimx --version
  else
    print_error "vimx installation failed"
    return 1
  fi

}

install_optional_packages() {
  print_info "Installing optional packages..."

  # Detect package manager and install
  if [ -f /data/data/com.termux/files/usr/bin/pkg ]; then
    # Termux
    print_info "Detected Termux environment"
    pkg install -y nodejs python
    pip install black flake8 autopep8
  elif command -v pacman &>/dev/null; then
    # Arch Linux
    print_info "Detected Arch Linux"
    sudo pacman -S --noconfirm nodejs npm python-pip
    pip install black flake8 autopep8
  elif command -v apt-get &>/dev/null; then
    # Debian/Ubuntu
    print_info "Detected Debian/Ubuntu"
    sudo apt-get update
    sudo apt-get install -y nodejs npm python3-pip
    pip3 install black flake8 autopep8
  else
    print_warning "Could not detect package manager"
    print_info "Please install optional tools manually"
  fi

  print_success "Optional tools installed"
}

show_next_steps() {
  print_header "Installation Complete!"

  echo ""
  echo -e "${GREEN}✓ Vim configuration installed successfully!${NC}"
  echo ""

  # Tampilkan info berdasarkan plugin manager
  if [ -f "${HOME}/.vim/autoload/plug.vim" ]; then
    echo -e "  ${CYAN}Plugin Manager:${NC} vim-plug"
    echo -e "  ${CYAN}Manage plugins:${NC} :PlugInstall, :PlugUpdate"
  elif [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo -e "  ${CYAN}Plugin Manager:${NC} packer.nvim"
    echo -e "  ${CYAN}Manage plugins:${NC} :PackerSync, :PackerUpdate"
  elif [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo -e "  ${CYAN}Plugin Manager:${NC} lazy.nvim"
    echo -e "  ${CYAN}Manage plugins:${NC} :Lazy sync, :Lazy update"
  fi

  echo ""
  echo -e "${WHITE}Next Steps:${NC}"
  echo ""
  echo -e "  ${YELLOW}vim${NC} (or ${YELLOW}nvim${NC}) - Start with new configuration"
  echo ""
  echo -e "${WHITE}Management Commands:${NC}"
  echo -e "  ${CYAN}vimx update${NC}        - Update plugins"
  echo -e "  ${CYAN}vimx system-update${NC} - Update configuration"
  echo -e "  ${CYAN}vimx doctor${NC}        - Check system health"
  echo -e "  ${CYAN}vimx help${NC}          - Show all commands"
  echo ""

  echo -e "${WHITE}Enjoy coding! 🚀${NC}"
  echo ""
}
