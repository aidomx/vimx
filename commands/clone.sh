#!/usr/bin/env bash

clone_repository() {
  print_header "Installing Vim Configuration"

  local src
  src="$(cd "$VIMX_ROOT" && pwd)"

  # Dijalankan dari folder lokal (mis. hasil ekstrak tarball): pakai kode
  # dari folder itu, JANGAN clone dari GitHub. Kalau tidak, perubahan lokal
  # akan tertimpa kode lama dari repo.
  if [ "${IS_REMOTE:-0}" -eq 0 ]; then
    if [ "$src" = "$INSTALL_DIR" ]; then
      print_info "Installing from current directory: $src"
    else
      print_info "Installing from local folder: $src"
      rm -rf "$INSTALL_DIR"
      mkdir -p "$(dirname "$INSTALL_DIR")"
      cp -r "$src" "$INSTALL_DIR"
    fi
    print_success "Configuration files ready"
    return 0
  fi

  # Mode remote (curl | bash): clone dari GitHub
  print_info "Cloning repository..."

  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
  fi

  git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

  print_success "Repository cloned successfully"
}
