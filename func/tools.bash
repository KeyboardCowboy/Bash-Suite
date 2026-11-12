#!/usr/bin/env bash
# tools.bash
# Message/validation helpers used by scripts in global/bin, plus cdb.

##
# Print the terminal width in columns (80 if there's no terminal).
##
function col_count() {
  local size
  size=$(stty size 2>/dev/null) || size="24 80"
  echo "${size#* }"
}

##
# Print a message with a right-aligned, colored status tag.
##
function print_error()   { print_message "$1" "${RED}[error]${RESET}"; }
function print_success() { print_message "$1" "${GREEN}[success]${RESET}"; }
function print_warning() { print_message "$1" "${YELLOW}[warning]${RESET}"; }

##
# Helper for the print_* functions: right-align TAG after MSG.
# (Not named "status": that's a read-only variable in zsh.)
##
function print_message() {
  local msg=$1 tag=$2 cols gap
  cols=$(col_count)
  gap=$(( cols - ${#msg} + ${#tag} - 11 ))   # same alignment math as before
  printf "%s %${gap}s\n" "$msg" "$tag"
}

##
# req_local / req_var: bash-only (${!1}, read -p); used by scripts in bin/.
#
# Ensure a local var is set.
##
function req_local() {
  local var=$1 val=${!1}

  if [ -z "$val" ]; then
    echo "$PRE Unable to define variable $var. Exiting..."
    exit 1
  fi
}

##
# Ensure a global variable is set and open the vars file if not.
##
function req_var() {
  local var=$1 val=${!1}

  if [ -z "$val" ]; then
    read -r -p "$PRE Missing variable $var. Press enter to continue. "
    vi ~/.bash_config/vars.bash
    exit 1
  fi
}

##
# Die if a command is not installed (for scripts; exits the shell).
##
function require_command {
  command -v "$1" >/dev/null 2>&1 || exit 1
}

##
# Jump back up to an ancestor directory by name.
#   ~/www/projects/myapp/web $ cdb projects   ->  ~/www/projects
#
# Goes to the FIRST (outermost) match. ${PWD%%"/name/"*} cuts the path at
# the first "/name/" and keeps the left side.
##
function cdb {
  local target="/$1/"
  [[ -n "$1" && "$PWD" == *"$target"* ]] || return 1
  cd -- "${PWD%%"$target"*}/$1" || return
}
