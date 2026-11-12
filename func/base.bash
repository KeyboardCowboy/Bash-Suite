#!/bin/bash
#
# base.bash
# General-purpose interactive helpers.

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
