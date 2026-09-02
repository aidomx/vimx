#!/usr/bin/env bash

# Load plugin modules
for plugin_file in "${VIMX_ROOT}/commands/plugin"/*.sh; do
  source "$plugin_file"
done

vimx_cmd_plugin() {
  if [ $# -gt 0 ]; then
    case "$1" in
    list | -l) vimx_cmd_list ;;
    add | -a) vimx_cmd_add "$2" ;;
    disable) vimx_cmd_disable "$2" ;;
    enable) vimx_cmd_enable "$2" ;;
    info) vimx_cmd_info "$2" ;;
    remove | -r) vimx_cmd_remove "$2" ;;
    search | -s) vimx_cmd_search "$2" ;;
    update | -u) vimx_cmd_update ;;
    edit | -e) edit_plugin_file ;;
    esac
    return 1
  fi

  interactive_plugin_manager
}
