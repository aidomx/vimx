#!/usr/bin/env bash

# Pilih binary editor untuk plugin manager.
# Urutan: $VIMX_EDITOR (jika diset dan tersedia) -> vim -> nvim.
vimx_editor() {
  if [ -n "${VIMX_EDITOR:-}" ] && command -v "$VIMX_EDITOR" > /dev/null 2>&1; then
    echo "$VIMX_EDITOR"
  elif command -v vim > /dev/null 2>&1; then
    echo "vim"
  elif command -v nvim > /dev/null 2>&1; then
    echo "nvim"
  else
    return 1
  fi
}

# Jalankan perintah ex (mis. PlugInstall) secara non-interaktif.
# Usage: vimx_run_plug_cmd [rc_file] ex_cmd...
#   rc_file kosong = pakai config default editor.
vimx_run_plug_cmd() {
  local rc=$1
  shift
  local editor
  editor=$(vimx_editor) || return 1

  if [ "$editor" = "nvim" ]; then
    "$editor" --headless ${rc:+-u "$rc"} "$@" -c 'qa!' > /dev/null 2>&1
  else
    "$editor" -N ${rc:+-u "$rc"} "$@" -c 'qa!' > /dev/null 2>&1
  fi
}

run_vim_pluginstall() {
  # Jalankan PlugInstall di background, kembalikan PID
  vimx_run_plug_cmd "" -c 'PlugInstall' &
  echo $!
}

run_vim_plugclean() {
  vimx_run_plug_cmd "" -c 'PlugClean[!]' &
  echo $!
}
