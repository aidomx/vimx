#!/usr/bin/env bash

print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_error()   { echo -e "${RED}✗${NC} $*" >&2; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_info()    { echo -e "${BLUE}ℹ${NC} $*"; }

print_header() {
  local title="$*"
  echo ""
  echo -e "${CYAN}┃${NC} ${WHITE}${title}${NC}"
}
