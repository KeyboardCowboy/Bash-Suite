#!/usr/bin/env bash
##
# Color Builder
#
# @param $color
#   BLACK | RED | GREEN | YELLOW | BLUE | VIOLET | CYAN | WHITE | NULL | RESET
#
# @param $luminosity
#   BRIGHT | DULL (default)
#
# @param $ground
#   BG | FG (default)
#
# Example: $(color GREEN BRIGHT BG)
##
function color {
  # Name -> ANSI code lookups use `case`, not associative arrays (declare -A),
  # so this works in macOS's bash 3.2 as well as bash 4+ and zsh.
  local ESC=$'\033'   # real ESC byte in both bash and zsh
  local RESET="${ESC}[0;37;00m"   # dull (0), white (37), null (00)

  # Handle Special Cases. `return`, not `exit`: color is a shell function,
  # so `exit` would close the terminal if called outside $( ).
  if [[ "$1" == 'RESET' ]]; then
    echo "${RESET}"
    return 0
  fi

  # Luminosity: BRIGHT -> 1, anything else -> 0 (DULL)
  local lumin=0
  if [[ "$2" == BRIGHT ]]; then
    lumin=1
  fi

  # Foreground color codes are 30-37; NULL is 00; unknown names are empty.
  local code
  case "$1" in
    BLACK)  code=30 ;;
    RED)    code=31 ;;
    GREEN)  code=32 ;;
    YELLOW) code=33 ;;
    BLUE)   code=34 ;;
    VIOLET) code=35 ;;
    CYAN)   code=36 ;;
    WHITE)  code=37 ;;
    NULL)   code=00 ;;
    *)      code='' ;;
  esac

  # Background codes are the foreground code + 10 (40-47).
  if [[ "$3" == BG && "$code" == 3[0-7] ]]; then
    code=$((code + 10))
  fi

  echo "${ESC}[${lumin};${code}m"
}

## Create basic colors
RED=$(color RED)
GREEN=$(color GREEN)
YELLOW=$(color YELLOW)
BLUE=$(color BLUE)
VIOLET=$(color VIOLET)
CYAN=$(color CYAN)
WHITE=$(color WHITE)
RESET=$(color RESET)
export RED GREEN YELLOW BLUE VIOLET CYAN WHITE RESET

export GREEN_UL="\033[4;32m"
