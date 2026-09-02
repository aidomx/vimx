#!/usr/bin/env bash

# Load language modules
for lang_file in "${VIMX_ROOT}/commands/language"/*.sh; do
  source "$lang_file"
done

vimx_cmd_language() {
  if [ $# -gt 0 ]; then
    local subcmd="$1"
    local arg="${2:-}"
    case "$subcmd" in
    list | -l) list_language ;;
    add | -a) add_language "$arg" ;;
    disable) disable_language "$arg" ;;
    enable) enable_language "$arg" ;;
    info) info_language "$arg" ;;
    remove | -r) remove_language "$arg" ;;
    edit | -e) edit_language_file "$arg" ;;
    *) print_error "Unknown subcommand: $subcmd"; echo "Run 'vimx lang help' for usage"; return 1 ;;
    esac
    return 0
  fi
  interactive_language
}
