#!/usr/bin/env bash

# ==============================
# Theme Manager for vimx
# ==============================

THEME_FILE="${VIMX_ROOT}/core/theme.vim"
UI_FILE="${VIMX_ROOT}/utils/ui.vim"
DEFAULT_THEME="gruvbox"

# Well-known Vim colorscheme plugins (name|repo|description)
KNOWN_THEME_PLUGINS=(
  "gruvbox|morhetz/gruvbox|Retro groove color scheme"
  "seoul256|junegunn/seoul256.vim|Low-contrast color scheme"
  "dracula|dracula/vim|Dark theme for Vim"
  "catppuccin|catppuccin/vim|Soothing pastel theme"
  "tokyonight|folke/tokyonight.nvim|Tokyo Night color scheme"
  "onedark|joshdick/onedark.vim|Dark One theme"
  "nord|arcticicestudio/nord-vim|Arctic, north-bluish theme"
  "solarized|lifepillar/vim-solarized8|Solarized colorscheme"
  "rose-pine|rose-pine/neovim|All natural pine, faux fur and a bit of soho vibes"
  "nightfox|EdenEast/nightfox.nvim|A dark Neovim theme"
  "kanagawa|rebelot/kanagawa.nvim|Kanagawa colorscheme"
  "monokai|crusoexia/vim-monokai|Monokai theme"
  "habamax|habamax/vim-gruvbox8|Gruvbox8 color scheme"
  "github|projekt0n/github-nvim-theme|GitHub theme"
  "embark|embark-theme/vim|A dark and vibrant theme"
  "sonokai|sainnhe/sonokai|High Contrast color scheme"
  "everforest|sainnhe/everforest|Comfortable green theme"
  "edge|sainnhe/edge|Comfortable color scheme"
  "PaperColor|NLKNguyen/papercolor-theme|Light and dark color scheme"
)

# Airline theme mapping: colorscheme name -> airline theme name
# Most colorschemes don't have matching airline themes.
# This maps them to the closest available airline theme.
AIRLINE_THEME_MAP=(
  "gruvbox|base16_gruvbox_dark_medium"
  "ghdark|base16_github"
  "dracula|base16_dracula"
  "catppuccin|deus"
  "tokyonight|night_owl"
  "onedark|onedark"
  "nord|nord_minimal"
  "solarized|solarized"
  "rose-pine|deus"
  "nightfox|deus"
  "kanagawa|deus"
  "monokai|molokai"
  "habamax|base16_gruvbox_dark_medium"
  "github|base16_github"
  "embark|deus"
  "sonokai|deus"
  "everforest|deus"
  "edge|deus"
  "PaperColor|papercolor"
  "seoul256|seoul256"
)

# ---- Main dispatcher ----
vimx_cmd_theme() {
  local subcmd="${1:-}"

  case "$subcmd" in
    list | ls)        theme_list ;;
    set | switch)     [ -n "${2:-}" ] && theme_set "$2" || theme_interactive ;;
    current | active) theme_show_current ;;
    add)              [ -n "${2:-}" ] && theme_add "$2" || { print_error "Usage: vimx theme add <theme-name>"; echo "Run 'vimx theme available' to see themes"; } ;;
    install)          [ -n "${2:-}" ] && theme_add "$2" || { print_error "Usage: vimx theme install <theme-name>"; } ;;
    update)           [ -n "${2:-}" ] && theme_update "$2" || theme_update_all ;;
    reset)            theme_reset ;;
    delete | rm)      [ -n "${2:-}" ] && theme_delete "$2" || { print_error "Usage: vimx theme delete <theme-name>"; } ;;
    search)           theme_search "${2:-}" ;;
    available)        theme_available ;;
    help | -h | --help) theme_help ;;
    "")               theme_interactive ;;
    *)                print_error "Unknown subcommand: $subcmd"; theme_help; return 1 ;;
  esac
}

# ---- Get installed theme names from plugins ----
_get_installed_themes() {
  local plugins_dir="${HOME}/.vim/plugged"
  [ -d "$plugins_dir" ] || return 0
  find "$plugins_dir" -path "*/colors/*.vim" -type f 2>/dev/null | sort | while read -r f; do
    basename "$f" .vim
  done
}

# ---- Get active theme name ----
get_active_theme() {
  if [ -f "$THEME_FILE" ]; then
    local theme
    theme=$(grep 'g:vimx_theme_active' "$THEME_FILE" 2>/dev/null | head -1 | sed "s/.*[\"']\([^\"']*\)[\"'].*/\1/")
    [ -n "$theme" ] && { echo "$theme"; return; }
  fi
  if [ -f "$UI_FILE" ]; then
    local theme
    theme=$(grep '^silent! colorscheme' "$UI_FILE" 2>/dev/null | head -1 | sed 's/.*colorscheme //')
    [ -n "$theme" ] && { echo "$theme"; return; }
  fi
  echo "$DEFAULT_THEME"
}

# ---- Find repo for a known theme ----
_find_theme_repo() {
  local name="$1"
  for entry in "${KNOWN_THEME_PLUGINS[@]}"; do
    IFS='|' read -r t_name t_repo t_desc <<< "$entry"
    if [ "$t_name" = "$name" ]; then
      echo "$t_repo"
      return 0
    fi
  done
  return 1
}

# ---- Check if an airline theme file exists ----
_airline_theme_exists() {
  local name="$1"
  local airline_themes_dir="${HOME}/.vim/plugged/vim-airline-themes/autoload/airline/themes"
  [ -f "${airline_themes_dir}/${name}.vim" ] && return 0
  # Also check built-in airline themes
  local airline_dir="${HOME}/.vim/plugged/vim-airline/autoload/airline/themes"
  [ -f "${airline_dir}/${name}.vim" ] && return 0
  return 1
}

# ---- Resolve airline theme for a given colorscheme ----
_resolve_airline_theme() {
  local colorscheme="$1"

  # 1. Try explicit mapping first
  for entry in "${AIRLINE_THEME_MAP[@]}"; do
    IFS="|" read -r cs_name airline_name <<< "$entry"
    if [ "$cs_name" = "$colorscheme" ]; then
      if _airline_theme_exists "$airline_name"; then
        echo "$airline_name"
        return 0
      fi
    fi
  done

  # 2. Try exact name match (e.g. gruvbox -> gruvbox)
  if _airline_theme_exists "$colorscheme"; then
    echo "$colorscheme"
    return 0
  fi

  # 3. Fallback: use "dark" for dark themes, "light" for light themes
  case "$colorscheme" in
    *light*|*bright*|*paper*|*solarized_light*)
      _airline_theme_exists "light" && { echo "light"; return 0; }
      ;;
  esac
  echo "dark"
  return 0
}

# ---- Detect colorscheme names from a plugin directory ----
_detect_colorschemes() {
  local plugin_dir="$1"
  local plugins_dir="${HOME}/.vim/plugged"

  # Find the actual plugin directory under plugged/
  local found_dir=""
  for dir in "${plugins_dir}"/*/; do
    local dir_name="${dir%/}"
    dir_name="${dir_name##*/}"
    if [ "$dir_name" = "$plugin_dir" ] || [ "$dir_name" = "${2:-}" ]; then
      found_dir="$dir"
      break
    fi
  done

  [ -z "$found_dir" ] || [ ! -d "$found_dir" ] && return 1

  # List available colorscheme files
  find "$found_dir" -path "*/colors/*.vim" -type f 2>/dev/null | while read -r f; do
    basename "$f" .vim
  done
}

# ---- Detect colorscheme name from repo (before install) ----
_detect_repo_colorschemes() {
  local repo="$1"
  # Try to fetch the colors/ directory listing from GitHub API
  if command -v curl &>/dev/null; then
    local api_url="https://api.github.com/repos/${repo}/contents/colors"
    local response
    response=$(curl -s --max-time 5 "$api_url" 2>/dev/null)
    if [ -n "$response" ] && echo "$response" | grep -q '"name"'; then
      echo "$response" | grep -o '"name": "[^"]*\.vim"' | sed 's/"name": "//;s/\.vim"//' | sort
      return 0
    fi
  fi
  return 1
}

# ---- Apply theme to config files ----
_apply_theme() {
  local target="$1"
  local old
  old=$(get_active_theme)

  [ "$old" = "$target" ] && { print_info "Theme is already '$target'"; return 0; }

  backup_config_file "$THEME_FILE" > /dev/null 2>&1 || true
  backup_config_file "$UI_FILE" > /dev/null 2>&1 || true

  if [ -f "$THEME_FILE" ]; then
    sed -i "s/^let g:vimx_theme_active=.*/let g:vimx_theme_active=\"${target}\"/" "$THEME_FILE"
  else
    echo "let g:vimx_theme_active=\"${target}\"" > "$THEME_FILE"
  fi

  if [ -f "$UI_FILE" ]; then
    sed -i "s/^silent! colorscheme .*/silent! colorscheme ${target}/" "$UI_FILE"
    local airline_theme
    airline_theme=$(_resolve_airline_theme "${target}")
    sed -i "s/^let g:airline_theme = .*/let g:airline_theme = '${airline_theme}'/" "$UI_FILE"
  fi

  echo -e "${GREEN}✓${NC} Theme switched: ${CYAN}${old}${NC} -> ${CYAN}${target}${NC}"
  echo ""
  echo -e "${BLUE}ℹ${NC} Restart Vim or run ${CYAN}:source ${UI_FILE}${NC} to apply"
}

# ===========================
# SUBCOMMANDS
# ===========================

# ---- list: show installed themes ----
theme_list() {
  echo -e "${CYAN}==========================================================${NC}"
  echo -e "${WHITE}Installed Themes${NC}"
  echo -e "${CYAN}==========================================================${NC}"

  local active_theme
  active_theme=$(get_active_theme)
  local themes=()
  while IFS= read -r t; do [ -n "$t" ] && themes+=("$t"); done < <(_get_installed_themes)

  if [ ${#themes[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No themes installed"
    echo ""
    echo -e "  Install: ${CYAN}vimx theme add gruvbox${NC}"
    echo -e "  Browse:  ${CYAN}vimx theme available${NC}"
    return 1
  fi

  echo ""
  for color in "${themes[@]}"; do
    local mark="  "
    local repo=""
    repo=$(_find_theme_repo "$color") || true
    local extra=""
    [ -n "$repo" ] && extra=" ${GRAY}($repo)${NC}"

    if [ "$color" = "$active_theme" ]; then
      echo -e "${GREEN}>>${NC} ${color}${extra}"
    else
      echo -e "   ${color}${extra}"
    fi
  done

  echo ""
  echo -e "  Total: ${#themes[@]}  |  Active: ${CYAN}${active_theme}${NC}"
  echo ""
  echo -e "  Switch:   ${CYAN}vimx theme set${NC}"
  echo -e "  Add more: ${CYAN}vimx theme add <name>${NC}"
}

# ---- current: show active theme ----
theme_show_current() {
  local active_theme
  active_theme=$(get_active_theme)
  echo -e "${CYAN}==========================================================${NC}"
  echo -e "${WHITE}Current Theme${NC}"
  echo -e "${CYAN}==========================================================${NC}"
  echo ""
  echo -e "  Active: ${CYAN}${active_theme}${NC}"
  echo ""
  echo "  Files:"
  echo -e "    theme.vim : ${THEME_FILE}"
  echo -e "    ui.vim    : ${UI_FILE}"
  echo ""
  echo -e "  Switch: ${CYAN}vimx theme set${NC}"
}

# ---- set: switch theme by name ----
theme_set() {
  local target="$1"
  [ -z "$target" ] && { echo -e "${RED}✗${NC} Theme name required"; return 1; }

  local found=false
  while IFS= read -r t; do
    [ "$t" = "$target" ] && { found=true; break; }
  done < <(_get_installed_themes)

  if [ "$found" = false ]; then
    echo -e "${RED}✗${NC} Theme '$target' not installed"
    echo ""
    local repo
    if repo=$(_find_theme_repo "$target"); then
      echo -e "  Install it: ${CYAN}vimx theme add ${target}${NC}"
    else
      echo -e "  Search:     ${CYAN}vimx theme search ${target}${NC}"
      echo -e "  Available:  ${CYAN}vimx theme available${NC}"
    fi
    return 1
  fi

  _apply_theme "$target"
}

# ---- add: install a new theme ----
theme_add() {
  local name="$1"
  [ -z "$name" ] && { echo -e "${RED}✗${NC} Usage: vimx theme add <theme-name-or-repo>"; return 1; }

  # Check if already installed
  while IFS= read -r t; do
    if [ "$t" = "$name" ]; then
      echo -e "${BLUE}ℹ${NC} Theme '$name' is already installed"
      echo -e "  Switch: ${CYAN}vimx theme set ${name}${NC}"
      return 0
    fi
  done < <(_get_installed_themes)

  # Resolve repo
  local repo=""
  local plugin_name=""
  if repo=$(_find_theme_repo "$name"); then
    plugin_name="$name"
  elif echo "$name" | grep -q '/'; then
    repo="$name"
    plugin_name="${name##*/}"
  else
    # Try common theme repos before falling back
    echo -e "${BLUE}ℹ${NC} Searching for '$name'..."
    for try_repo in "vim-scripts/${name}" "${name}/${name}.vim" "${name}/vim-${name}"; do
      if command -v curl &>/dev/null; then
        local status
        status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "https://api.github.com/repos/${try_repo}" 2>/dev/null)
        if [ "$status" = "200" ]; then
          repo="$try_repo"
          plugin_name="${try_repo##*/}"
          break
        fi
      fi
    done
    if [ -z "$repo" ]; then
      echo -e "${RED}✗${NC} Could not find theme '${name}'"
      echo -e "  Try: ${CYAN}vimx theme add user/repo${NC}"
      echo -e "  Or:  ${CYAN}vimx theme search ${name}${NC}"
      return 1
    fi
  fi

  # Detect available colorschemes BEFORE install (via GitHub API)
  local available_colorschemes=()
  while IFS= read -r cs; do
    [ -n "$cs" ] && available_colorschemes+=("$cs")
  done < <(_detect_repo_colorschemes "$repo")

  # Install the plugin
  echo -e "${BLUE}ℹ${NC} Installing theme: ${repo}..."
  vimx_cmd_add "$repo"

  # Detect colorschemes AFTER install (from local files)
  local installed_colorschemes=()
  while IFS= read -r cs; do
    [ -n "$cs" ] && installed_colorschemes+=("$cs")
  done < <(_detect_colorschemes "$plugin_name" "$plugin_name")

  # If no colorschemes found via local scan, use pre-install detection
  if [ ${#installed_colorschemes[@]} -eq 0 ] && [ ${#available_colorschemes[@]} -gt 0 ]; then
    installed_colorschemes=("${available_colorschemes[@]}")
  fi

  if [ ${#installed_colorschemes[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} Theme installed but no colorscheme files found"
    echo -e "  Manual setup: ${CYAN}vimx theme set <colorscheme-name>${NC}"
    return 0
  fi

  # If only one colorscheme, auto-apply it
  if [ ${#installed_colorschemes[@]} -eq 1 ]; then
    local detected_name="${installed_colorschemes[0]}"
    echo -e "${BLUE}ℹ${NC} Detected colorscheme: ${CYAN}${detected_name}${NC}"
    _apply_theme "$detected_name"
    return 0
  fi

  # Multiple colorschemes found — let user pick
  echo -e "${BLUE}ℹ${NC} Found ${#installed_colorschemes[@]} colorschemes:"
  echo ""
  local idx=1
  for cs in "${installed_colorschemes[@]}"; do
    echo -e "  ${GREEN}${idx}.${NC} ${cs}"
    idx=$((idx + 1))
  done
  echo ""
  read -p "$(echo -e "${CYAN}Select [1-${#installed_colorschemes[@]}]: ${NC}")" choice

  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#installed_colorschemes[@]} ]; then
    _apply_theme "${installed_colorschemes[$((choice - 1))]}"
  else
    echo -e "${BLUE}ℹ${NC} Skipped. Use ${CYAN}vimx theme set <name>${NC} to activate later"
  fi
}

# ---- update: update a theme plugin ----
theme_update() {
  local name="$1"

  if [ -z "$name" ]; then
    theme_update_all
    return
  fi

  local plugins_dir="${HOME}/.vim/plugged"
  local plugin_dir=""

  for entry in "${KNOWN_THEME_PLUGINS[@]}"; do
    IFS='|' read -r t_name t_repo t_desc <<< "$entry"
    if [ "$t_name" = "$name" ]; then
      local repo_name="${t_repo##*/}"
      if [ -d "${plugins_dir}/${repo_name}" ]; then
        plugin_dir="${plugins_dir}/${repo_name}"
        break
      fi
    fi
  done

  [ -z "$plugin_dir" ] && [ -d "${plugins_dir}/${name}" ] && plugin_dir="${plugins_dir}/${name}"

  if [ -z "$plugin_dir" ] || [ ! -d "$plugin_dir" ]; then
    echo -e "${RED}✗${NC} Theme '$name' not found in plugins"
    return 1
  fi

  if [ ! -d "${plugin_dir}/.git" ]; then
    echo -e "${RED}✗${NC} Not a git repository: $plugin_dir"
    return 1
  fi

  echo -e "${BLUE}ℹ${NC} Updating $name..."
  if (cd "$plugin_dir" && git pull --quiet 2>&1); then
    echo -e "${GREEN}✓${NC} Updated: $name"
  else
    echo -e "${RED}✗${NC} Failed to update: $name"
  fi
}

# ---- update all themes ----
theme_update_all() {
  echo -e "${CYAN}==========================================================${NC}"
  echo -e "${WHITE}Updating All Themes${NC}"
  echo -e "${CYAN}==========================================================${NC}"

  local plugins_dir="${HOME}/.vim/plugged"
  local updated=0
  local failed=0

  for entry in "${KNOWN_THEME_PLUGINS[@]}"; do
    IFS='|' read -r t_name t_repo t_desc <<< "$entry"
    local repo_name="${t_repo##*/}"
    local dir="${plugins_dir}/${repo_name}"

    if [ -d "$dir/.git" ]; then
      printf "  %-25s" "$t_name"
      if (cd "$dir" && git pull --quiet 2>&1); then
        echo -e "${GREEN}OK${NC}"
        updated=$((updated+1))
      else
        echo -e "${RED}FAIL${NC}"
        failed=$((failed+1))
      fi
    fi
  done

  echo ""
  echo -e "  Updated: ${updated}  |  Failed: ${failed}"
}

# ---- reset: reset to default theme ----
theme_reset() {
  local current
  current=$(get_active_theme)

  if [ "$current" = "$DEFAULT_THEME" ]; then
    echo -e "${BLUE}ℹ${NC} Already using default theme: $DEFAULT_THEME"
    return 0
  fi

  echo -e "${YELLOW}⚠${NC} Reset theme: ${current} -> ${DEFAULT_THEME}"
  read -p "Continue? [y/N]: " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo -e "${BLUE}ℹ${NC} Cancelled"; return 0; }

  _apply_theme "$DEFAULT_THEME"
}

# ---- delete: remove a theme plugin ----
theme_delete() {
  local name="$1"
  [ -z "$name" ] && { echo -e "${RED}✗${NC} Usage: vimx theme delete <theme-name>"; return 1; }

  local current
  current=$(get_active_theme)
  if [ "$name" = "$current" ]; then
    echo -e "${RED}✗${NC} Cannot delete active theme '$name'"
    echo -e "  Switch first: ${CYAN}vimx theme set <other>${NC}"
    return 1
  fi

  local plugins_dir="${HOME}/.vim/plugged"
  local plugin_dir=""

  for entry in "${KNOWN_THEME_PLUGINS[@]}"; do
    IFS='|' read -r t_name t_repo t_desc <<< "$entry"
    if [ "$t_name" = "$name" ]; then
      local repo_name="${t_repo##*/}"
      [ -d "${plugins_dir}/${repo_name}" ] && { plugin_dir="${plugins_dir}/${repo_name}"; break; }
    fi
  done
  [ -z "$plugin_dir" ] && [ -d "${plugins_dir}/${name}" ] && plugin_dir="${plugins_dir}/${name}"

  if [ -z "$plugin_dir" ] || [ ! -d "$plugin_dir" ]; then
    echo -e "${RED}✗${NC} Theme '$name' not found"
    return 1
  fi

  echo -e "${YELLOW}⚠${NC} This will delete: $plugin_dir"
  read -p "Confirm delete? [y/N]: " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo -e "${BLUE}ℹ${NC} Cancelled"; return 0; }

  rm -rf "$plugin_dir"
  echo -e "${GREEN}✓${NC} Deleted: $name"

  local plugins_file="${VIMX_ROOT}/core/plugins.vim"
  if [ -f "$plugins_file" ]; then
    for entry in "${KNOWN_THEME_PLUGINS[@]}"; do
      IFS='|' read -r t_name t_repo t_desc <<< "$entry"
      if [ "$t_name" = "$name" ]; then
        sed -i "\|Plug '${t_repo}'|d" "$plugins_file"
        echo -e "${BLUE}ℹ${NC} Removed from plugins.vim"
        break
      fi
    done
  fi
}

# ---- search: find themes on GitHub ----
theme_search() {
  local query="${1:-vim colorscheme}"

  if ! command -v curl &>/dev/null; then
    echo -e "${RED}✗${NC} curl is required for search"
    return 1
  fi

  local encoded
  encoded=$(echo "$query vim theme" | sed 's/ /+/g')
  local api_url="https://api.github.com/search/repositories?q=${encoded}&sort=stars&order=desc&per_page=15"

  local response
  response=$(curl -s --max-time 10 "$api_url" 2>/dev/null)

  if [ -z "$response" ] || echo "$response" | grep -q '"message"'; then
    echo -e "${RED}✗${NC} No results found for '${query}'"
    return 1
  fi

  # Get total count
  local total_count=0
  if command -v jq &>/dev/null; then
    total_count=$(echo "$response" | jq -r '.total_count // 0')
  else
    total_count=$(echo "$response" | grep -o '"total_count":[0-9]*' | head -1 | cut -d: -f2)
    total_count=${total_count:-0}
  fi

  local installed_list
  installed_list=$(_get_installed_themes)

  # Build output
  local output=""
  output+="Search results for: ${CYAN}${query}${NC} (theme)\n"
  output+="Page: 1 | Results: 1-15 of ${total_count}\n"
  output+="$(printf '=%.0s' {1..70})\n\n"

  local count=1
  if command -v jq &>/dev/null; then
    while IFS='|' read -r repo stars desc; do
      local rname="${repo##*/}"
      local tag=""
      echo "$installed_list" | grep -qx "$rname" && tag=" ${GREEN}[installed]${NC}"

      local short_desc
      [ ${#desc} -gt 70 ] && short_desc="${desc:0:67}..." || short_desc="$desc"

      output+="${GREEN}$(printf '%3d' $count).${NC} ${CYAN}$(printf '%-35s' "$repo")${NC}${tag}\n"
      output+="     ${YELLOW}*${NC} ${WHITE}${stars}${NC} stars\n"
      output+="     ${GRAY}${short_desc}${NC}\n"
      output+="     Install: ${GREEN}vimx theme add ${repo}${NC}\n\n"
      count=$((count + 1))
    done < <(echo "$response" | jq -r '.items[] | "\(.full_name)|\(.stargazers_count)|\(.description // "No description")"')
  else
    # Fallback: use python3 if jq not available
    if command -v python3 &>/dev/null; then
      while IFS='|' read -r repo stars desc; do
        local rname="${repo##*/}"
        local tag=""
        echo "$installed_list" | grep -qx "$rname" && tag=" ${GREEN}[installed]${NC}"

        local short_desc
        [ ${#desc} -gt 70 ] && short_desc="${desc:0:67}..." || short_desc="$desc"

        output+="${GREEN}$(printf '%3d' $count).${NC} ${CYAN}$(printf '%-35s' "$repo")${NC}${tag}\n"
        output+="     ${YELLOW}*${NC} ${WHITE}${stars}${NC} stars\n"
        output+="     ${GRAY}${short_desc}${NC}\n"
        output+="     Install: ${GREEN}vimx theme add ${repo}${NC}\n\n"
        count=$((count + 1))
      done < <(echo "$response" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for i in data.get('items', []):
    name = i.get('full_name', '')
    stars = i.get('stargazers_count', 0)
    desc = i.get('description', 'No description') or 'No description'
    print(f'{name}|{stars}|{desc}')
" 2>/dev/null)
    fi
  fi

  output+="$(printf '=%.0s' {1..70})\n"
  output+="${BOLD}Navigation:${NC}\n"
  output+="  - Press ${GREEN}q${NC} to quit\n"
  output+="  - Use ${GREEN}arrow keys${NC} or ${GREEN}Page Up/Down${NC} to scroll\n"
  output+="\n"

  if [ "$total_count" -gt 15 ]; then
    output+="${BOLD}More results available!${NC}\n"
    output+="Run: ${CYAN}vimx search '${query}' theme${NC}\n"
  fi

  echo -e "$output" | less -R -X -F -K
}

# ---- available: show well-known themes ----
theme_available() {
  echo -e "${CYAN}==========================================================${NC}"
  echo -e "${WHITE}Well-Known Vim Themes${NC}"
  echo -e "${CYAN}==========================================================${NC}"

  local plugins_dir="${HOME}/.vim/plugged"
  local active_theme
  active_theme=$(get_active_theme)
  local installed_list
  installed_list=$(_get_installed_themes)

  echo ""
  for entry in "${KNOWN_THEME_PLUGINS[@]}"; do
    IFS='|' read -r theme_name repo desc <<< "$entry"

    local status="${RED}--${NC}"
    echo "$installed_list" | grep -qx "$theme_name" && status="${GREEN}OK${NC}"
    [ "$theme_name" = "$active_theme" ] && status="${GREEN}OK${NC} ${CYAN}*active${NC}"

    local name_col
    name_col=$(printf '%-18s' "$theme_name")
    local repo_col
    repo_col=$(printf '%-35s' "$repo")

    echo -e "  ${status} ${name_col} ${repo_col} ${GRAY}${desc}${NC}"
  done

  echo ""
  echo -e "  Install: ${CYAN}vimx theme add <name>${NC}"
  echo -e "  Switch:  ${CYAN}vimx theme set <name>${NC}"
}

# ---- interactive: pick from installed ----
theme_interactive() {
  local active_theme
  active_theme=$(get_active_theme)
  local themes=()
  while IFS= read -r t; do [ -n "$t" ] && themes+=("$t"); done < <(_get_installed_themes)

  if [ ${#themes[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No themes installed"
    echo ""
    echo -e "  Install: ${CYAN}vimx theme add gruvbox${NC}"
    echo -e "  Browse:  ${CYAN}vimx theme available${NC}"
    return 1
  fi

  echo -e "${CYAN}==========================================================${NC}"
  echo -e "${WHITE}Theme Manager${NC}"
  echo -e "${CYAN}==========================================================${NC}"
  echo ""
  echo -e "  Active: ${CYAN}${active_theme}${NC}"
  echo ""

  local idx=1
  for color in "${themes[@]}"; do
    local repo=""
    repo=$(_find_theme_repo "$color") || true
    local extra=""
    [ -n "$repo" ] && extra="  ${GRAY}${repo}${NC}"

    if [ "$color" = "$active_theme" ]; then
      echo -e "${GREEN}>>${NC} $(printf '%2d' "$idx"). ${color}${extra}"
    else
      echo -e "   $(printf '%2d' "$idx"). ${color}${extra}"
    fi
    idx=$((idx + 1))
  done

  echo ""
  echo -e "  ${GRAY}0. Cancel${NC}"
  echo ""
  read -p "$(echo -e "${CYAN}Select [1-${#themes[@]}]: ${NC}")" choice

  [ "$choice" = "0" ] || [ -z "$choice" ] && { echo -e "${BLUE}ℹ${NC} Cancelled"; return 0; }

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#themes[@]} ]; then
    echo -e "${RED}✗${NC} Invalid selection"
    return 1
  fi

  _apply_theme "${themes[$((choice - 1))]}"
}

# ---- help ----
theme_help() {
  echo -e "${CYAN}vimx theme${NC} - Theme manager"
  echo ""
  echo -e "${WHITE}USAGE:${NC}"
  echo "  vimx theme                    Interactive theme selector"
  echo "  vimx theme list               List installed themes"
  echo "  vimx theme current            Show active theme"
  echo "  vimx theme set <name>         Switch to a theme"
  echo "  vimx theme add <name|repo>    Install a new theme"
  echo "  vimx theme update [name]      Update theme(s)"
  echo "  vimx theme reset              Reset to default (gruvbox)"
  echo "  vimx theme delete <name>      Remove a theme"
  echo "  vimx theme search <query>     Search themes on GitHub"
  echo "  vimx theme available          Show well-known themes"
  echo ""
  echo -e "${WHITE}EXAMPLES:${NC}"
  echo "  vimx theme                          # Pick from installed"
  echo "  vimx theme add dracula              # Install dracula"
  echo "  vimx theme add catppuccin/vim       # Install from repo"
  echo "  vimx theme update gruvbox           # Update one theme"
  echo "  vimx theme update                   # Update all themes"
  echo "  vimx theme delete seoul256          # Remove a theme"
  echo "  vimx theme reset                    # Back to gruvbox"
  echo "  vimx theme search tokyonight        # Search GitHub"
  echo "  vimx theme available                # Browse popular themes"
}
