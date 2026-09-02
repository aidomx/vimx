#!/usr/bin/env bash

# VIMX Path Configuration
setup_vimx_paths() {
  # Determine VIMX_ROOT
  if [ -n "${VIMX_ROOT}" ]; then
    # Use explicit VIMX_ROOT
    export VIMX_ROOT="${VIMX_ROOT}"
  elif [ -d "${HOME}/.config/vim" ]; then
    # Default installation location
    export VIMX_ROOT="${HOME}/.config/vim"
  elif [ -d "${HOME}/.local/vim" ]; then
    # Fallback to old location
    export VIMX_ROOT="${HOME}/.local/vim"
  else
    # Current script location (development)
    export VIMX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  fi

  # Initial runtime vim
  export VIMX_INIT="${VIMX_ROOT}/init.vim"

  # Core directories
  export VIMX_CORE_DIR="${VIMX_ROOT}/core"
  export VIMX_COMMANDS_DIR="${VIMX_ROOT}/commands"
  export VIMX_LIB_DIR="${VIMX_ROOT}/lib"
  export VIMX_DOCS_DIR="${VIMX_ROOT}/docs"
  export VIMX_LANGS_DIR="${VIMX_ROOT}/langs"

  # Core files
  export VIMX_SETTINGS_FILE="${VIMX_CORE_DIR}/settings.vim"
  export VIMX_PLUGINS_FILE="${VIMX_CORE_DIR}/plugins.vim"
  export VIMX_MAPPINGS_FILE="${VIMX_CORE_DIR}/mappings.vim"

  # Default files (templates)
  export VIMX_SETTINGS_DEFAULT="${VIMX_CORE_DIR}/settings.default.vim"
  export VIMX_PLUGINS_DEFAULT="${VIMX_CORE_DIR}/plugins.default.vim"
  export VIMX_MAPPINGS_DEFAULT="${VIMX_CORE_DIR}/mappings.default.vim"

  # coc paths
  export VIMX_COC_DIR="${HOME}/.config/coc"
  export VIMX_COC_EXTENSIONS="${VIMX_COC_DIR}/extensions"

  # User data
  export VIMX_DATA_DIR="${HOME}/.local/share/vimx"
  export VIMX_BACKUP_DIR="${VIMX_DATA_DIR}/backups"

  # Internet connection
  export VIMX_INTERNET_CONNECTION=${VIMX_INTERNET_CONNECTION:-0}

  # Is remote
  export IS_REMOTE=${IS_REMOTE:-0}

  # Create directories if they don't exist
  mkdir -p "${VIMX_DATA_DIR}" "${VIMX_BACKUP_DIR}"
}

# Initialize paths
setup_vimx_paths

# Utility functions
get_vimx_root() {
  echo "${VIMX_ROOT}"
}

get_core_file() {
  local file_type=$1
  case "$file_type" in
  "settings") echo "${VIMX_SETTINGS_FILE}" ;;
  "plugins") echo "${VIMX_PLUGINS_FILE}" ;;
  "mappings") echo "${VIMX_MAPPINGS_FILE}" ;;
  *) echo "" ;;
  esac
}

get_default_file() {
  local file_type=$1
  case "$file_type" in
  "settings") echo "${VIMX_SETTINGS_DEFAULT}" ;;
  "plugins") echo "${VIMX_PLUGINS_DEFAULT}" ;;
  "mappings") echo "${VIMX_MAPPINGS_DEFAULT}" ;;
  *) echo "" ;;
  esac
}

backup_config_file() {
  local file_path=$1
  local backup_name=$(basename "$file_path")
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local backup_file="${VIMX_BACKUP_DIR}/${backup_name}.${timestamp}.bak"

  if [ -f "$file_path" ]; then
    cp "$file_path" "$backup_file"
    echo "$backup_file"
  else
    echo ""
  fi
}
