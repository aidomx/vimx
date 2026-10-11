#!/usr/bin/env bash

# Tanya user: coc-settings.json minimal atau lengkap, lalu salin ke lokasi coc.
#   Vim    -> ~/.vim/coc-settings.json
#   Neovim -> ~/.config/nvim/coc-settings.json
setup_coc_settings() {
  print_header "CoC Settings"

  local src_dir="${VIMX_ROOT:-$HOME/.config/vim}"
  local minimal="${src_dir}/coc-settings.minimal.json"
  local full="${src_dir}/coc-settings.json"

  if [ ! -f "$minimal" ] || [ ! -f "$full" ]; then
    print_warning "coc-settings file not found, skipping"
    return 0
  fi

  echo ""
  echo -e "Choose coc-settings.json:"
  echo -e "  ${GREEN}1${NC}) Minimal (recommended, ringan untuk HP/Termux)"
  echo -e "  ${YELLOW}2${NC}) Lengkap (termasuk daftar class Tailwind/Headwind, file besar)"
  echo ""

  # Tanpa jawaban (EOF / stdin ditutup) jatuh ke default minimal, tidak menghentikan installer
  local answer=""
  answer=$(ask "Enter your choice [1-2] (default 1): ")

  local choice=1
  case "${answer:-1}" in
    1) choice=1 ;;
    2) choice=2 ;;
    *) print_warning "Invalid choice, using minimal"; choice=1 ;;
  esac

  local chosen label
  if [ "$choice" = "2" ]; then
    chosen="$full"
    label="lengkap"
  else
    chosen="$minimal"
    label="minimal"
  fi

  local targets=("$HOME/.vim/coc-settings.json")
  if command -v nvim > /dev/null 2>&1; then
    targets+=("$HOME/.config/nvim/coc-settings.json")
  fi

  local target backup_path
  for target in "${targets[@]}"; do
    mkdir -p "$(dirname "$target")"

    if [ -f "$target" ]; then
      backup_path="${target}.backup.$(date +%Y%m%d_%H%M%S)"
      cp "$target" "$backup_path"
      print_info "Backed up existing coc-settings to $backup_path"
    fi

    cp -f "$chosen" "$target"
    print_success "coc-settings.json ($label) -> $target"
  done
}
