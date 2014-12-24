##
# Color Builder
#
# @param $color
#   BLACK | RED | GREEN | YELLOW | BLUE | VIOLET | CYAN | WHITE
#
# @param $luminosity
#   BRIGHT | DULL (default)
#
# @param $ground
#   BG | FG (default)
##
function color {
  # Define colors and luminosity
  local DULL=0
  local BRIGHT=1

  local FG_BLACK=30
  local FG_RED=31
  local FG_GREEN=32
  local FG_YELLOW=33
  local FG_BLUE=34
  local FG_VIOLET=35
  local FG_CYAN=36
  local FG_WHITE=37

  local BG_BLACK=40
  local BG_RED=41
  local BG_GREEN=42
  local BG_YELLOW=43
  local BG_BLUE=44
  local BG_VIOLET=45
  local BG_CYAN=46
  local BG_WHITE=47

  local FG_NULL=00
  local BG_NULL=00

  local ESC="\033"
  local RESET="$ESC[${DULL};${FG_WHITE};${FG_NULL}m"

  # Handle Special Cases
  if [[ "$1" == 'RESET' ]]; then
    echo ${RESET}
    exit 1
  fi

  # Set the luminosity, ground and color
  LUMIN=$2
  if [[ "$LUMIN" != "BRIGHT" ]]; then
    LUMIN="DULL"
  fi
  GROUND=$3
  if [[ "$GROUND" != "BG" ]]; then
    GROUND="FG"
  fi

  local COLOR="${GROUND}_${1}"

  echo "$ESC[${!LUMIN};${!COLOR}m"
}

## Create basic colors
export RED=$(color RED)
export GREEN=$(color GREEN)
export YELLOW=$(color YELLOW)
export BLUE=$(color BLUE)
export VIOLET=$(color VIOLET)
export CYAN=$(color CYAN)
export WHITE=$(color WHITE)
export RESET=$(color RESET)
