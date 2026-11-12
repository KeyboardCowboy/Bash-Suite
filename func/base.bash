#!/bin/bash
#
# base.bash
# General-purpose interactive helpers.

##
# ll / lls: long listing (hidden files, human sizes) framed by a green
# divider and the current path; lls sorts by size. Extra args go to ls.
# Functions, not aliases, so the chpwd hook (hooks.zsh) can call ll.
##
function _bash_config_framed_ls {
  local bar
  bar="$(color GREEN BRIGHT)------------------------------------$(color RESET)"
  echo "$bar"
  echo -e "${SYSCOLOR}${PWD}${RESET}"
  ls "$@"
  echo -e "${SYSCOLOR}${PWD}${RESET}"
  echo "$bar"
}
function ll  { _bash_config_framed_ls -ahl "$@"; }
function lls { _bash_config_framed_ls -ahlS "$@"; }

##
# Make a directory tree (parents included); optionally cd into it.
#   mkd a/b/c         create a/b/c
#   mkd -d a/b/c      create a/b/c, then cd into it
#   mkd -d x y/z      create both, then cd into the LAST one (y/z)
##
function mkd {
  local go=0
  if [[ "$1" == -d ]]; then
    go=1
    shift
  fi
  if [[ $# -eq 0 ]]; then
    echo "usage: mkd [-d] dir..." >&2
    return 1
  fi
  command mkdir -p -- "$@" || return
  if (( go )); then
    cd -- "${@: -1}" || return
  fi
}
