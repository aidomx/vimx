#!/usr/bin/env bash

# Paket manager yang terdeteksi: pkg (Termux), pacman (Arch), apt (Debian/Ubuntu)
PM=""

detect_pm() {
  if is_native_termux; then
    PM="pkg"
  elif command -v pacman &> /dev/null; then
    PM="pacman"
  elif command -v apt-get &> /dev/null; then
    PM="apt"
  else
    PM=""
  fi
}

# Jalankan perintah sebagai root jika perlu (tanpa sudo jika sudah root)
as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

# Jalankan perintah di background dengan spinner, output masuk ke log.
# Jika gagal, tampilkan beberapa baris terakhir dari log.
# Usage: run_with_progress "Pesan" perintah args...
run_with_progress() {
  local msg=$1
  shift

  local log
  log=$(mktemp "${TMPDIR:-/tmp}/vimx-run.XXXXXX.log")

  "$@" > "$log" 2>&1 &
  local pid=$!

  PROGRESS_DONE_SPINNER="[selesai]" progress spinner "$pid" "$msg"

  local rc=0
  wait "$pid" || rc=$?

  if [ $rc -ne 0 ]; then
    print_warning "$msg: gagal (exit $rc)"
    tail -n 3 "$log" | sed 's/^/    /'
  fi

  rm -f "$log"
  return $rc
}

# Pasang paket satu per satu: satu nama paket yang tidak ada di distro
# tidak membatalkan paket lain.
pm_install() {
  local pkg
  for pkg in "$@"; do
    local rc=0
    case "$PM" in
      pkg) run_with_progress "Memasang $pkg" pkg install -y "$pkg" || rc=$? ;;
      pacman) run_with_progress "Memasang $pkg" as_root pacman -S --noconfirm --needed "$pkg" || rc=$? ;;
      apt) run_with_progress "Memasang $pkg" as_root apt-get install -y "$pkg" || rc=$? ;;
    esac

    if [ $rc -eq 0 ]; then
      print_success "$pkg terpasang"
    else
      print_warning "Lewati $pkg (cek nama paket di distro kamu)"
    fi
  done
}

# ---------- Tool per kategori ----------

install_node_tools() {
  case "$PM" in
    pkg) pm_install nodejs ;;
    pacman) pm_install nodejs npm ;;
    apt) pm_install nodejs npm ;;
  esac

  if command -v npm &> /dev/null; then
    if run_with_progress "Memasang prettier (npm)" npm install -g prettier; then
      print_success "prettier terpasang"
    else
      print_warning "Jalankan manual: npm install -g prettier"
    fi
  fi
}

# pip dengan fallback --break-system-packages (PEP 668)
pip_install_user() {
  python3 -m pip install --user "$@" \
    || python3 -m pip install --user --break-system-packages "$@"
}

install_python_tools() {
  case "$PM" in
    pkg)
      pm_install python
      if command -v python3 &> /dev/null; then
        if run_with_progress "Memasang black, flake8, autopep8 (pip)" pip_install_user black flake8 autopep8; then
          print_success "black, flake8, autopep8 terpasang"
        else
          print_warning "Jalankan manual: python3 -m pip install --user black flake8 autopep8"
        fi
      fi
      ;;
    pacman) pm_install python-black python-flake8 python-autopep8 ;;
    apt) pm_install black flake8 autopep8 ;;
  esac
}

install_go_tools() {
  case "$PM" in
    pkg) pm_install golang ;;
    pacman) pm_install go ;;
    apt) pm_install golang-go ;;
  esac
}

install_c_tools() {
  case "$PM" in
    pkg) pm_install clang clangd ;;
    pacman) pm_install clang clang-tools-extra ;;
    apt) pm_install clang clangd clang-format ;;
  esac
}

install_shell_tools() {
  case "$PM" in
    pkg) pm_install shellcheck shfmt ;;
    pacman) pm_install shellcheck shfmt ;;
    apt) pm_install shellcheck shfmt ;;
  esac
}

install_ripgrep() {
  pm_install ripgrep
}

install_build_tools() {
  case "$PM" in
    pkg) pm_install cmake ninja ;;
    pacman) pm_install cmake ninja ;;
    apt) pm_install cmake ninja-build ;;
  esac
}

# Build rbot dari folder source: install.sh --dev (rbot menyesuaikan platform sendiri)
build_rbot() {
  (cd "$1" && bash install.sh --dev)
}

# rbot tidak ada di repo distro. Default: repo GitHub resmi.
# Bisa juga path folder/tarball lokal, atau "-" untuk lewati.
install_rbot() {
  local rbot_default_repo="https://github.com/aidomx/rbot.git"

  echo ""
  echo -e "rbot: masukkan path folder/tarball source, atau URL git."
  local rbot_src
  rbot_src=$(ask "rbot source (Enter = ${rbot_default_repo}, ketik - untuk lewati): ")
  rbot_src="${rbot_src:-$rbot_default_repo}"

  if [ "$rbot_src" = "-" ]; then
    print_info "Melewati rbot"
    return 0
  fi

  local src_root="${HOME}/.local/src/rbot"

  if [ -d "$rbot_src" ]; then
    src_root="$rbot_src"
  elif [[ "$rbot_src" == *.tar.gz || "$rbot_src" == *.tgz ]] && [ -f "$rbot_src" ]; then
    rm -rf "$src_root" && mkdir -p "$src_root"
    run_with_progress "Mengekstrak rbot" tar -xzf "$rbot_src" -C "$src_root" \
      || { print_error "Gagal mengekstrak $rbot_src"; return 1; }
  else
    rm -rf "$src_root"
    mkdir -p "$(dirname "$src_root")"
    run_with_progress "Clone rbot dari $rbot_src" git clone --depth 1 "$rbot_src" "$src_root" \
      || { print_error "Gagal clone $rbot_src"; return 1; }
  fi

  # install.sh bisa berada di root atau satu level di dalam arsip
  local installer
  installer=$(find "$src_root" -maxdepth 2 -name install.sh 2> /dev/null | head -1)
  if [ -z "$installer" ]; then
    print_error "install.sh tidak ditemukan di $src_root"
    return 1
  fi

  if run_with_progress "Membangun rbot" build_rbot "$(dirname "$installer")"; then
    if command -v rbot &> /dev/null; then
      print_success "rbot terpasang: $(command -v rbot)"
    else
      print_warning "Build selesai, tapi 'rbot' belum ada di PATH"
    fi
  else
    print_error "Build rbot gagal. Jalankan manual di $(dirname "$installer")"
    return 1
  fi
}

# ---------- Alur utama ----------

setup_optional_tools() {
  print_header "Optional Tools"

  echo ""
  echo -e "Would you like to install recommended tools?"
  echo ""
  echo -e "  ${CYAN}1${NC}) Node.js + npm (web development, prettier)"
  echo -e "  ${CYAN}2${NC}) Python tools (black, flake8, autopep8)"
  echo -e "  ${CYAN}3${NC}) Go (Go development)"
  echo -e "  ${CYAN}4${NC}) C/C++ tools (clang, clangd, clang-format)"
  echo -e "  ${CYAN}5${NC}) Shell tools (shellcheck, shfmt)"
  echo -e "  ${CYAN}6${NC}) ripgrep (dipakai :Rg / gg)"
  echo -e "  ${CYAN}7${NC}) Build tools (cmake, ninja)"
  echo -e "  ${CYAN}8${NC}) rbot (build tool C, dari path atau URL git)"
  echo ""

  local install_tools
  install_tools=$(ask "Install optional tools? [y/N]: ")

  if [[ ! "$install_tools" =~ ^[Yy]$ ]]; then
    print_info "Skipping optional tools"
    print_info "You can install them later manually"
    return 0
  fi

  detect_pm
  if [ -z "$PM" ]; then
    print_warning "Could not detect package manager"
    print_info "Please install optional tools manually"
    return 0
  fi
  print_info "Package manager: $PM"

  echo ""
  echo -e "Nomor dipisahkan spasi (contoh: ${YELLOW}1 4 6${NC})."
  echo -e "${YELLOW}a${NC} atau Enter = semua kecuali rbot (8)."
  echo ""

  local sel
  sel=$(ask "Pilihan: ")

  local selected=()
  if [ -z "$sel" ] || [ "$sel" = "a" ]; then
    selected=(1 2 3 4 5 6 7)
  else
    local n
    for n in $sel; do
      case "$n" in
        [1-8]) selected+=("$n") ;;
        *) print_warning "Pilihan tidak valid, dilewati: $n" ;;
      esac
    done
  fi

  # Minta sudo di depan (foreground). Di background, sudo yang minta password
  # akan terhenti tanpa terlihat, itulah yang membuat proses terasa diam.
  export DEBIAN_FRONTEND=noninteractive
  if [ "$PM" != "pkg" ] && [ "$(id -u)" -ne 0 ] && command -v sudo &> /dev/null; then
    sudo -v || print_warning "sudo gagal, pemasangan paket bisa gagal"
  fi

  if [ "$PM" = "apt" ]; then
    run_with_progress "Memperbarui daftar paket (apt)" as_root apt-get update \
      || print_warning "apt-get update gagal, lanjut dengan daftar lama"
  fi

  local n
  for n in ${selected[@]+"${selected[@]}"}; do
    echo ""
    case "$n" in
      1) print_header "Node.js"; install_node_tools ;;
      2) print_header "Python"; install_python_tools ;;
      3) print_header "Go"; install_go_tools ;;
      4) print_header "C/C++"; install_c_tools ;;
      5) print_header "Shell"; install_shell_tools ;;
      6) print_header "ripgrep"; install_ripgrep ;;
      7) print_header "Build tools"; install_build_tools ;;
      8) print_header "rbot"; install_rbot ;;
    esac
  done

  echo ""
  print_success "Optional tools selesai"
}
