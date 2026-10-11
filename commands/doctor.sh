#!/usr/bin/env bash

vimx_cmd_doctor() {
  print_header "Vim Configuration Doctor"
  echo -e "${WHITE}Checking your Vim/Neovim setup for potential issues...${NC}"
  echo ""

  local total_checks=0
  local passed_checks=0
  local warning_checks=0
  local failed_checks=0

  # 1. Check Vim/Neovim Installation
  print_section "Editor Installation"
  check_vim_installation
  check_neovim_installation

  # 2. Check Plugin Managers
  print_section "Plugin Managers"
  check_plugin_managers

  # 3. Check Dependencies
  print_section "Dependencies"
  check_doctor_dependencies

  # 4. Check Configuration Files
  print_section "Configuration Files"
  check_config_files

  # 5. Check Plugin Health
  print_section "Plugin Health"
  check_plugin_health

  # 6. Check Performance
  print_section "Performance"
  check_performance

  # Summary
  print_section "Summary"
  echo -e "${WHITE}Total checks:${NC} $total_checks"
  echo -e "${GREEN}Passed:${NC} $passed_checks"
  echo -e "${YELLOW}Warnings:${NC} $warning_checks"
  echo -e "${RED}Failed:${NC} $failed_checks"
  echo ""

  if [ $failed_checks -eq 0 ] && [ $warning_checks -eq 0 ]; then
    print_success "Your Vim configuration is healthy!"
  elif [ $failed_checks -eq 0 ]; then
    print_warning "Your configuration has some warnings but should work fine"
  else
    print_error "Your configuration has issues that need attention"
  fi

  # Show recommendations
  if [ $failed_checks -gt 0 ] || [ $warning_checks -gt 0 ]; then
    show_recommendations
  fi
}

print_section() {
  local title=$1
  echo ""
  echo -e "${CYAN}┃${NC} ${BOLD}${WHITE}${title}${NC}"
}

check_vim_installation() {
  total_checks=$((total_checks + 1))
  if command -v vim &> /dev/null; then
    local vim_version=$(vim --version | head -1 | sed 's/.*version //')
    print_success "Vim installed: $vim_version"
    passed_checks=$((passed_checks + 1))
  else
    print_error "Vim not installed"
    failed_checks=$((failed_checks + 1))
  fi
}

check_neovim_installation() {
  total_checks=$((total_checks + 1))
  if command -v nvim &> /dev/null; then
    local nvim_version=$(nvim --version | head -1 | sed 's/.*version //')
    print_success "Neovim installed: $nvim_version"
    passed_checks=$((passed_checks + 1))
  else
    print_warning "Neovim not installed (optional)"
    warning_checks=$((warning_checks + 1))
  fi
}

check_plugin_managers() {
  local managers_found=0

  # Check vim-plug
  total_checks=$((total_checks + 1))
  if [ -f "${HOME}/.vim/autoload/plug.vim" ] || [ -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    print_success "vim-plug installed"
    managers_found=$((managers_found + 1))
    passed_checks=$((passed_checks + 1))
  else
    print_warning "vim-plug not installed"
    warning_checks=$((warning_checks + 1))
  fi

  # Check packer.nvim
  total_checks=$((total_checks + 1))
  if [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    print_success "packer.nvim installed"
    managers_found=$((managers_found + 1))
    passed_checks=$((passed_checks + 1))
  else
    print_info "packer.nvim not installed"
  fi

  # Check lazy.nvim
  total_checks=$((total_checks + 1))
  if [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    print_success "lazy.nvim installed"
    managers_found=$((managers_found + 1))
    passed_checks=$((passed_checks + 1))
  else
    print_info "lazy.nvim not installed"
  fi

  # Overall plugin manager status
  total_checks=$((total_checks + 1))
  if [ $managers_found -gt 0 ]; then
    print_success "Plugin manager detected ($managers_found found)"
    passed_checks=$((passed_checks + 1))
  else
    print_error "No plugin manager installed"
    failed_checks=$((failed_checks + 1))
  fi
}

check_doctor_dependencies() {
  local deps=("git" "curl")

  for dep in "${deps[@]}"; do
    total_checks=$((total_checks + 1))
    if command -v "$dep" &> /dev/null; then
      local version=$("$dep" --version 2> /dev/null | head -1)
      print_success "$dep: installed"
      passed_checks=$((passed_checks + 1))
    else
      print_error "$dep: not installed"
      failed_checks=$((failed_checks + 1))
    fi
  done

  # Optional dependencies
  local optional_deps=("node" "python3" "npm" "pip3" "jq" "wget")

  for dep in "${optional_deps[@]}"; do
    total_checks=$((total_checks + 1))
    if command -v "$dep" &> /dev/null; then
      print_success "$dep: installed"
      passed_checks=$((passed_checks + 1))
    else
      print_info "$dep: not installed (optional)"
    fi
  done
}

check_config_files() {
  local config_files=(
    "${HOME}/.vimrc"
    "${HOME}/.config/nvim/init.vim"
    "${HOME}/.config/nvim/init.lua"
    "${VIM_CONFIG_DIR}/init.vim"
    "${VIM_CONFIG_DIR}/core/plugins.vim"
    "${VIM_CONFIG_DIR}/core/settings.vim"
    "${VIM_CONFIG_DIR}/core/mappings.vim"
  )

  for file in "${config_files[@]}"; do
    total_checks=$((total_checks + 1))
    if [ -f "$file" ]; then
      print_success "Config: $(basename "$file")"
      passed_checks=$((passed_checks + 1))

      # Check if file is readable
      if [ -r "$file" ]; then
        # Check for syntax errors in Vim files
        if [[ "$file" == *.vim ]]; then
          check_vim_syntax "$file"
        fi
      else
        print_warning "Config: $(basename "$file") not readable"
        warning_checks=$((warning_checks + 1))
      fi
    else
      if [[ "$file" == *".vimrc"* ]] || [[ "$file" == *"init.vim"* ]] || [[ "$file" == *"plugins.vim"* ]]; then
        print_error "Config: $(basename "$file") missing"
        failed_checks=$((failed_checks + 1))
      else
        print_info "Config: $(basename "$file") not found (optional)"
      fi
    fi
  done
}

check_vim_syntax() {
  local file=$1
  local filename
  filename=$(basename "$file")

  local editor
  editor=$(vimx_editor 2> /dev/null) || return 0

  case "$filename" in
    "init.vim" | ".vimrc")
      print_info "Syntax: $filename (basic check only)"
      return 0
      ;;
  esac

  # Skrip pemeriksa ditulis ke file: Vim tidak mengurai -c multi-baris dengan benar
  local check_script
  check_script=$(mktemp "${TMPDIR:-/tmp}/vimx-syntax.XXXXXX.vim")
  cat > "$check_script" << EOF
try
  source ${file}
  echo 'VALID'
catch
  echo 'ERROR: ' . v:exception
endtry
qall!
EOF

  local flags=(-u NONE -i NONE -es)
  [ "$editor" = "vim" ] && flags+=(-N)

  local out
  out=$(timeout 10 "$editor" "${flags[@]}" -S "$check_script" < /dev/null 2>&1) || true
  rm -f "$check_script"

  if echo "$out" | grep -q "VALID"; then
    print_success "Syntax: $filename valid"
    passed_checks=$((passed_checks + 1))
  elif echo "$out" | grep -q "ERROR:"; then
    local msg
    msg=$(echo "$out" | grep "ERROR:" | head -1 | sed 's/ERROR: *//')
    # E117 (fungsi tidak ada), E492 (command tidak ada), E185 (colorscheme tidak ada):
    # biasanya berarti plugin belum dimuat, bukan error sintaks
    if echo "$msg" | grep -qE "E(117|121|185|492)"; then
      print_info "Syntax: $filename dilewati (butuh plugin yang belum dimuat)"
      passed_checks=$((passed_checks + 1))
    else
      print_error "Syntax: $filename has issues"
      echo -e "       ${GRAY}${msg}${NC}"
      failed_checks=$((failed_checks + 1))
    fi
  else
    print_warning "Syntax: $filename tidak bisa diperiksa (timeout atau editor gagal)"
    warning_checks=$((warning_checks + 1))
  fi
}

check_plugin_health() {
  local plugin_manager=$(detect_plugin_manager)

  case "$plugin_manager" in
    "vim-plug")
      check_vimplug_health
      ;;
    "packer.nvim")
      check_packer_health
      ;;
    "lazy.nvim")
      check_lazy_health
      ;;
    *)
      print_info "No active plugin manager detected for health check"
      ;;
  esac
}

check_vimplug_health() {
  total_checks=$((total_checks + 1))
  local plugins_dir="${HOME}/.vim/plugged"

  if [ -d "$plugins_dir" ]; then
    local plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
    plugin_count=$((plugin_count - 1)) # subtract the directory itself

    if [ $plugin_count -gt 0 ]; then
      print_success "Plugins: $plugin_count installed"
      passed_checks=$((passed_checks + 1))

      # Check for broken plugins
      local broken_plugins=0
      for plugin_dir in "$plugins_dir"/*; do
        if [ -d "$plugin_dir" ] && [ ! -d "$plugin_dir/.git" ]; then
          broken_plugins=$((broken_plugins + 1))
        fi
      done

      if [ $broken_plugins -gt 0 ]; then
        total_checks=$((total_checks + 1))
        print_warning "Plugins: $broken_plugins may be broken"
        warning_checks=$((warning_checks + 1))
      fi
    else
      print_warning "Plugins: directory exists but no plugins installed"
      warning_checks=$((warning_checks + 1))
    fi
  else
    print_info "Plugins: no plugins directory found"
  fi
}

check_packer_health() {
  total_checks=$((total_checks + 1))
  local plugins_dir="${HOME}/.local/share/nvim/site/pack/packer"

  if [ -d "$plugins_dir" ]; then
    local start_count=$(find "$plugins_dir/start" -maxdepth 1 -type d 2> /dev/null | wc -l)
    local opt_count=$(find "$plugins_dir/opt" -maxdepth 1 -type d 2> /dev/null | wc -l)
    local total_count=$((start_count + opt_count - 2)) # subtract the directories themselves

    if [ $total_count -gt 0 ]; then
      print_success "Packer: $total_count plugins ($start_count start, $opt_count opt)"
      passed_checks=$((passed_checks + 1))
    else
      print_warning "Packer: no plugins installed"
      warning_checks=$((warning_checks + 1))
    fi
  else
    print_info "Packer: no plugins directory found"
  fi
}

check_lazy_health() {
  total_checks=$((total_checks + 1))
  local plugins_dir="${HOME}/.local/share/nvim/lazy"

  if [ -d "$plugins_dir" ]; then
    local plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
    plugin_count=$((plugin_count - 1)) # subtract the directory itself

    if [ $plugin_count -gt 0 ]; then
      print_success "Lazy: $plugin_count plugins installed"
      passed_checks=$((passed_checks + 1))
    else
      print_warning "Lazy: no plugins installed"
      warning_checks=$((warning_checks + 1))
    fi
  else
    print_info "Lazy: no plugins directory found"
  fi
}

check_performance() {
  # Check editor startup time (tanpa terminal: tidak bisa menunggu input)
  total_checks=$((total_checks + 1))
  local editor
  if editor=$(vimx_editor 2> /dev/null); then
    local log start_time end_time startup_time
    log=$(mktemp "${TMPDIR:-/tmp}/vimx-startup.XXXXXX.log")

    start_time=$(date +%s%3N)
    if [ "$editor" = "nvim" ]; then
      timeout 10 nvim --headless --startuptime "$log" -c 'qa!' < /dev/null > /dev/null 2>&1 || true
    else
      timeout 10 vim -n --not-a-term --startuptime "$log" -c 'qa!' < /dev/null > /dev/null 2>&1 || true
    fi
    end_time=$(date +%s%3N)
    startup_time=$((end_time - start_time))
    DOCTOR_STARTUP_MS=$startup_time

    if [ $startup_time -lt 1000 ]; then
      print_success "Performance: $editor startup ${startup_time}ms (fast)"
      passed_checks=$((passed_checks + 1))
    elif [ $startup_time -lt 3000 ]; then
      print_warning "Performance: $editor startup ${startup_time}ms (moderate)"
      warning_checks=$((warning_checks + 1))
    else
      print_error "Performance: $editor startup ${startup_time}ms (slow)"
      failed_checks=$((failed_checks + 1))
    fi
    rm -f "$log"
  else
    print_info "Performance: cannot test (Vim/Neovim not installed)"
  fi

  # Check disk space for plugins
  total_checks=$((total_checks + 1))
  local plugin_dirs=(
    "${HOME}/.vim/plugged"
    "${HOME}/.local/share/nvim/site/pack"
    "${HOME}/.local/share/nvim/lazy"
  )

  local total_size=0
  local dir size
  for dir in "${plugin_dirs[@]}"; do
    if [ -d "$dir" ]; then
      size=$(du -s "$dir" 2> /dev/null | cut -f1) || size=0
      total_size=$((total_size + ${size:-0}))
    fi
  done

  local size_mb=$((total_size / 1024))
  if [ $size_mb -lt 500 ]; then
    print_success "Disk: plugins use ${size_mb}MB"
    passed_checks=$((passed_checks + 1))
  elif [ $size_mb -lt 1000 ]; then
    print_warning "Disk: plugins use ${size_mb}MB (large)"
    warning_checks=$((warning_checks + 1))
  else
    print_error "Disk: plugins use ${size_mb}MB (very large)"
    failed_checks=$((failed_checks + 1))
  fi
}

show_recommendations() {
  print_section "Recommendations"

  if command -v vim &> /dev/null && ! vim --version | grep -q "+python3"; then
    echo -e "  ${YELLOW}•${NC} Consider installing Vim with Python3 support for better plugin compatibility"
  fi

  if [ ! -f "${HOME}/.vim/autoload/plug.vim" ] && [ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo -e "  ${YELLOW}•${NC} Install a plugin manager: ${CYAN}vimx install${NC}"
  fi

  if ! command -v git &> /dev/null; then
    echo -e "  ${RED}•${NC} Install git: ${CYAN}sudo apt install git${NC} (Ubuntu/Debian)"
  fi

  if ! command -v curl &> /dev/null; then
    echo -e "  ${RED}•${NC} Install curl: ${CYAN}sudo apt install curl${NC} (Ubuntu/Debian)"
  fi

  # Pakai hasil pengukuran dari check_performance (jangan jalankan Vim lagi di sini)
  if [ "${DOCTOR_STARTUP_MS:-0}" -gt 2000 ]; then
    echo -e "  ${YELLOW}•${NC} Optimize startup time: ${CYAN}vimx disable slow_plugins${NC}"
    echo -e "  ${YELLOW}•${NC} Check startup profile: ${CYAN}vim --startuptime startup.log${NC}"
  fi

  echo ""
  print_info "Run specific commands to fix issues:"
  echo -e "  ${CYAN}vimx install${NC}    - Install missing components"
  echo -e "  ${CYAN}vimx update${NC}     - Update plugins and manager"
  echo -e "  ${CYAN}vimx clean${NC}      - Remove unused plugins"
  echo -e "  ${CYAN}vimx doctor${NC}     - Run this check again"
}
