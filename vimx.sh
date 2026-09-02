#!/usr/bin/env bash

# Set strict-ish mode
set -euo pipefail

DEV_MODE="${VIMX_DEV_MODE:-0}"

# Load libs (adjust path if script installed elsewhere)
VIMX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $DEV_MODE -eq 0 ] && command -v vimx >/dev/null 2>&1; then
  VIMX_ROOT="$HOME/.config/vim"
fi

# Source libs
source "${VIMX_ROOT}/lib/paths.sh"
source "${VIMX_ROOT}/lib/fs.sh"
source "${VIMX_ROOT}/lib/colors.sh"
source "${VIMX_ROOT}/lib/logging.sh"
source "${VIMX_ROOT}/lib/execs.sh"
source "${VIMX_ROOT}/lib/progress.sh"
source "${VIMX_ROOT}/lib/table.sh"

# Source command implementations
for f in "${VIMX_ROOT}/commands"/*.sh; do
  source "$f"
done

export VIMX_VERSION="1.1.0"

main() {
  if [ $# -eq 0 ]; then
    vimx_cmd_help || true
    exit 0
  fi

  local cmd=$1
  shift

  case "${cmd}" in
  add) vimx_cmd_add "$@" ;;
  backup) vimx_cmd_backup "$@" ;;
  clean) vimx_cmd_clean "$@" ;;
  coc) vimx_cmd_coc "$@" ;;
  disable) vimx_cmd_disable "$@" ;;
  doctor) vimx_cmd_doctor "$@" ;;
  editmap) vimx_cmd_editmap "$@" ;;
  enable) vimx_cmd_enable "$@" ;;
  --help | -h | help) vimx_cmd_help "$@" ;;
  info) vimx_cmd_info "$@" ;;
  install) vimx_cmd_install "$@" ;;
  lang) vimx_cmd_language "$@" ;;
  list | ls) vimx_cmd_list "$@" ;;
  plugin | -p) vimx_cmd_plugin "$@" ;;
  remove | rm) vimx_cmd_remove "$@" ;;
  reinstall) vimx_cmd_reinstall "$@" ;;
  reset) vimx_cmd_reset "$@" ;;
  restore) vimx_cmd_restore "$@" ;;
  search) vimx_cmd_search "$@" ;;
  set) vimx_cmd_set "$@" ;;
  system-update) vimx_cmd_system_update "$@" ;;
  theme) vimx_cmd_theme "$@" ;;
  update) vimx_cmd_update "$@" ;;
  --version | -v | version) vimx_cmd_version "$VIMX_VERSION" ;;
  *)
    print_error "Unknown command: ${cmd}"
    echo ""
    echo -e "Run ${CYAN}vimx help${NC} to see available commands"
    exit 1
    ;;
  esac
}

main "$@"
