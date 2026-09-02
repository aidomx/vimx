#!/usr/bin/env bash

add_language() {
  local lang="${1}"
  local lang_file="${VIMX_LANGS_DIR}/${lang}.vim"

  if grep -q "#define LANGUAGE" "$VIMX_INIT" && grep -q "#enddef LANGUAGE" "$VIMX_INIT"; then
    if grep -q "runtime! langs/$lang.vim" "$VIMX_INIT"; then
      print_warning "Configuration ${CYAN}$lang${NC} is already exists"
      return 0
    fi

    tmp_file=$(mktemp)
    awk -v lang="$lang" '
    /#enddef LANGUAGE/ && !added {
    print "runtime! " "langs/" lang ".vim"
    added=1
  }
{ print }
    ' "$VIMX_INIT" >"$tmp_file" && mv "$tmp_file" "$VIMX_INIT"

    if [ -f "$lang_file" ]; then
      print_warning "Added to configuration is successfully but language file: ${CYAN}$lang_file${NC} is already exists"
    else
      touch "$lang_file"
      print_success "Added new language ${CYAN}$lang_file${NC} is successfully"
    fi
  else
    cat >>"$VIMX_INIT" <<EOF
" Load language configurations
" Don't remove 'define LANGUAGE' and 'enddef LANGUAGE' from comment
" #define LANGUAGE
runtime! langs/${lang}.vim
" #enddef LANGUAGE
EOF
    # Buat file bahasa
    touch "$lang_file"
    print_success "Added new language ${CYAN}$lang${NC} with new section"
  fi
}

disable_language() {
  local lang="${1}"
  local lang_pattern="runtime! langs/${lang}.vim"

  if [[ ! -f "$VIMX_INIT" ]]; then
    print_error "Configuration file $VIMX_INIT not found"
    return 1
  fi

  if ! grep -q "$lang_pattern" "$VIMX_INIT"; then
    print_warning "Language ${CYAN}$lang${NC} not found"
    return 0
  fi

  if grep -q "$lang_pattern" "$VIMX_INIT" || grep -q "^[^\"].*$lang_pattern" "$VIMX_INIT"; then
    tmp_file=$(mktemp)
    awk -v pattern="$lang_pattern" '
      $0 ~ pattern && !/^"/ {
        $0 = "\" " $0
      }
      { print }
    ' "$VIMX_INIT" >"$tmp_file" && mv "$tmp_file" "$VIMX_INIT"

    print_success "Language ${CYAN}$lang${NC} disabled successfully"
  else
    print_warning "Language ${CYAN}$lang${NC} is already disabled"
  fi
}

enable_language() {
  local lang="${1}"

  if [[ ! -f "$VIMX_INIT" ]]; then
    print_error "Configuration file $VIMX_INIT not found"
    return 1
  fi

  if grep -q "^\" *runtime! langs/${lang}.vim" "$VIMX_INIT"; then
    tmp_file=$(mktemp)
    awk -v lang="$lang" '
      /^" *runtime! langs\/.*\.vim/ {
        if (index($0, "langs/" lang ".vim") > 0) {
          sub(/^" */, "")
        }
      }
      { print }
    ' "$VIMX_INIT" >"$tmp_file" && mv "$tmp_file" "$VIMX_INIT"

    print_success "Language ${CYAN}$lang${NC} enabled successfully"
  elif grep -q "^runtime! langs/${lang}.vim" "$VIMX_INIT"; then
    print_warning "Language ${CYAN}$lang${NC} is already enabled"
  else
    print_error "Language ${CYAN}$lang${NC} not found in configuration"
    return 1
  fi
}

info_language() {
  local lang="${1}"
  local lang_file="${VIMX_LANGS_DIR}/${lang}.vim"

  if [[ ! -f "$lang_file" ]]; then
    print_error "Language ${CYAN}$lang${NC} not found"
    return 1
  fi

  local status="Disabled"
  if grep -q "^runtime! langs/${lang}.vim" "$VIMX_INIT"; then
    status="${GREEN}Enabled${NC}"
  elif grep -q "^\" *runtime! langs/${lang}.vim" "$VIMX_INIT"; then
    status="${YELLOW}Disabled${NC}"
  else
    status="${RED}Not in config${NC}"
  fi

  local file_size=$(stat -f%z "$lang_file" 2>/dev/null || stat -c%s "$lang_file" 2>/dev/null)
  local line_count=$(wc -l <"$lang_file")
  local created_date=$(stat -f%SB "$lang_file" 2>/dev/null || stat -c%y "$lang_file" 2>/dev/null | cut -d' ' -f1)

  print_header "Language Information: ${CYAN}$lang${NC}"

  local info_data=(
    "Status|$(echo -e $status)"
    "File|$lang_file"
    "Size|$file_size bytes"
    "Lines|$line_count"
    "Created|$created_date"
  )

  for info in "${info_data[@]}"; do
    IFS='|' read -r label value <<<"$info"
    printf "  ${YELLOW}%-10s:${NC} %s\n" "$label" "$value"
  done

  echo ""
  print_header "File Preview"
  if [[ $line_count -gt 20 ]]; then
    echo -e "  ${GRAY}(Showing first 20 lines)${NC}"
    head -n 20 "$lang_file" | sed 's/^/  /'
    echo -e "  ${GRAY}... and $((line_count - 20)) more lines${NC}"
  else
    cat "$lang_file" | sed 's/^/  /'
  fi
}

list_language() {
  local languages=()
  while IFS= read -r f; do [ -n "$f" ] && languages+=("$f"); done < <(find "${VIMX_LANGS_DIR}" -name "*.vim" 2>/dev/null | sort)
  local current=0
  local table_data=()

  print_header "Supported Languages"
  echo ""

  if [ ${#languages[@]} -eq 0 ]; then
    print_warning "No language configurations found"
    return 1
  fi

  for lang in "${languages[@]}"; do
    current=$((current + 1))
    local lang_name
    lang_name=$(basename "$lang" .vim)
    table_data+=("$current|$lang_name")
  done

  create_simple_table "No,Language" "${table_data[@]}"
  echo ""
  echo -e "Edit: ${CYAN}vimx lang edit <name>${NC}"
  echo -e "Add:  ${CYAN}vimx lang add <name>${NC}"
}

remove_language() {
  local lang="${1}"
  local lang_file="${VIMX_LANGS_DIR}/${lang}.vim"
  local lang_pattern="runtime! langs/${lang}.vim"

  if [[ ! -f "$VIMX_INIT" ]]; then
    print_error "Configuration file $VIMX_INIT not found"
    return 1
  fi

  if grep -q "$lang_pattern" "$VIMX_INIT"; then
    tmp_file=$(mktemp)
    awk -v pattern="$lang_pattern" '
      $0 !~ pattern { print }
    ' "$VIMX_INIT" >"$tmp_file" && mv "$tmp_file" "$VIMX_INIT"

    print_success "Language ${CYAN}$lang${NC} removed from configuration"
  else
    print_warning "Language ${CYAN}$lang${NC} not found in configuration"
  fi

  if [[ -f "$lang_file" ]]; then
    local question=$(echo -e "Delete language file ${CYAN}${lang_file}${NC}? (y/N): ")
    read -p "$question" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -f "$lang_file"
      print_success "Language file ${CYAN}$lang_file${NC} deleted"
    else
      print_warning "Language file ${CYAN}$lang_file${NC} kept"
    fi
  fi
}
