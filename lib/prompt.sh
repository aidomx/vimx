#!/usr/bin/env bash

# Baca jawaban dari terminal, bukan dari stdin.
# Saat installer dijalankan lewat `curl ... | bash`, stdin berisi isi script,
# sehingga read langsung EOF. Dengan `set -e`, itu menghentikan script diam-diam.
# Jika EOF atau tidak ada terminal, jawaban kosong dikembalikan dan
# pemanggil memakai default-nya.
#
# Usage: answer=$(ask "Pilihan [1-3]: ")
ask() {
  local prompt=$1
  local answer=""

  if { : < /dev/tty; } 2> /dev/null; then
    # Buang sisa input (mis. Enter dari prompt sebelumnya) agar tidak
    # dianggap sebagai jawaban untuk prompt ini
    while read -r -t 0.1 -n 1000 _discard < /dev/tty; do :; done
    read -r -p "$prompt" answer < /dev/tty || answer=""
  else
    read -r -p "$prompt" answer || answer=""
  fi

  printf '%s\n' "$answer"
}
