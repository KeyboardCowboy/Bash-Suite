#!/bin/sh
# File: tools.inc
# Author: Chris Albrecht
# Description: Various global tools for bash functionality.

##
# Get the current column placement and the total number of columns available
# in the current display.
##
function col_count() {
  COLS=`stty size 2>&1`
  POS=${COLS% *}
  TOT=${COLS#* }

  echo `expr $TOT`
}

##
# Echo an ERROR message.
#
function print_error() {
  local STATUS=`echo -e "${RED}[error]${NORMAL}"`
  print_message "$1" "$STATUS"
}

##
# Echo a SUCCESS message.
#
function print_success() {
  STATUS=`echo -e "${GREEN}[success]${NORMAL}"`
  print_message "$1" "$STATUS"
}

##
# Echo a WARNING message.
#
function print_warning() {
  STATUS=`echo -e "${YELLOW}[warning]${YELLOW}"`
  print_message "$1" "$STATUS"
}

##
# Helper function for preparing messages.
##
function print_message() {
  local MSG=$1
  local STATUS=$2

  local COLS=$(col_count)
  local PAD=${#STATUS}
  local LEN=${#MSG}
  local GAP=`expr $COLS - $LEN + $PAD - 11`

  printf "%s %${GAP}s\n" "$MSG" "$STATUS"
}

##
# Ensure a local var is set.
#
function req_local() {
  VAR=$1
  VAL=${!1}

  if [ -z "$VAL" ]; then
    echo "$PRE Unable to define variable $VAR. Exiting..."
    exit 1
  fi
}

##
# Ensure a global variable is set and open the vars file if not.
##
function req_var() {
  VAR=$1
  VAL=${!1}

  if [ -z "$VAL" ]; then
    read -p "$PRE Missing variable $VAR. Press any key to continue. " X
    vi ~/.bash_config/vars.inc
    exit 1
  fi
}

##
# Die if a command is not installed.
##
function require_command {
  command -v $1 >/dev/null 2>&1 || exit 1;
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
