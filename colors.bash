#!/usr/bin/env bash
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
#
# Example: $(color GREEN BRIGHT BG)
##
function color {
  # BG = BACKGROUND

  # BO = BOLD
  # BR = BRIGHT
  # UL = UNDERLINE
  # BL = BLACK TEXT
  # IN = INVERTED


  # Regular ORDER OF SPECIFICATION
  # 1. Color (required)
  # 2. BO
  # 3. BR
  # 4. UL

  # Background ORDER OF SPECIFICATION
  # 1. Color (required)
  # 2. BG (required)
  # 3. BR [back]
  # 4. IN [back]
  # Use a 'T' to start text specifications, then
  # 5. BL
  # 6. BO
  # 7. BR

  # Reset
  RESET='\033[0m';

  # Blacks
  BL=''

  # Reds
  RD=''

  # Greens
  GREEN="\033[0;32m"
  GREEN_BO="\033[1;32m"
  GREEN_BR="\033[0;92m"
  GREEN_BOBR="\033[1;92m"
  GREEN_UL="\033[4;32m"

#  # GREEN_BRUL
#  echo -e "\033[4;92m Normal Bright Underline.${off}\n"
#
#  # GREEN_BG
#  echo -e "\033[42m      Background Dull Normal Dull.${off}\n"
#
#  # GREEN_BGTBL
#  echo -e "\033[7;32m      Background Dull Normal Black.${off}\n"
#
#  # GREEN_BGBR
#  echo -e "\033[0;102m      Background Bright Normal Dull.${off}\n"
#
#  # GREEN_BGBRTBO
#  echo -e "\033[1;102m      Background Bright Bold Bright.${off}\n"
#
#  # GREEN_BGINTBR
#  echo -e "\033[7;102m      Background Invert Normal Bright.${off}\n"

  # Yellows
  YL=''

  # Blues
  BU=''

  # Purples
  PU=''

  # Cyans
  CY=''

  # Whites
  WH=''


  # Regular Colors
   Black='\e[0;30m'        # Black
     Red='\e[0;31m'          # Red
   Green='\e[0;32m'        # Green
  Yellow='\e[0;33m'       # Yellow
    Blue='\e[0;34m'         # Blue
  Purple='\e[0;35m'       # Purple
    Cyan='\e[0;36m'         # Cyan
   White='\e[0;37m'        # White

  # Bold
   BBlack='\e[1;30m'       # Black
     BRed='\e[1;31m'         # Red
   BGreen='\e[1;32m'       # Green
  BYellow='\e[1;33m'      # Yellow
    BBlue='\e[1;34m'        # Blue
  BPurple='\e[1;35m'      # Purple
    BCyan='\e[1;36m'        # Cyan
   BWhite='\e[1;37m'       # White

  # Underline
   UBlack='\e[4;30m'       # Black
     URed='\e[4;31m'         # Red
   UGreen='\e[4;32m'       # Green
  UYellow='\e[4;33m'      # Yellow
    UBlue='\e[4;34m'        # Blue
  UPurple='\e[4;35m'      # Purple
    UCyan='\e[4;36m'        # Cyan
   UWhite='\e[4;37m'       # White

  # Background
   On_Black='\e[40m'       # Black
     On_Red='\e[41m'         # Red
   On_Green='\e[42m'       # Green
  On_Yellow='\e[43m'      # Yellow
    On_Blue='\e[44m'        # Blue
  On_Purple='\e[45m'      # Purple
    On_Cyan='\e[46m'        # Cyan
   On_White='\e[47m'       # White

  # High Intensity
   IBlack='\e[0;90m'       # Black
     IRed='\e[0;91m'         # Red
   IGreen='\e[0;92m'       # Green
  IYellow='\e[0;93m'      # Yellow
    IBlue='\e[0;94m'        # Blue
  IPurple='\e[0;95m'      # Purple
    ICyan='\e[0;96m'        # Cyan
   IWhite='\e[0;97m'       # White

  # Bold High Intensity
   BIBlack='\e[1;90m'      # Black
     BIRed='\e[1;91m'        # Red
   BIGreen='\e[1;92m'      # Green
  BIYellow='\e[1;93m'     # Yellow
    BIBlue='\e[1;94m'       # Blue
  BIPurple='\e[1;95m'     # Purple
    BICyan='\e[1;96m'       # Cyan
   BIWhite='\e[1;97m'      # White

  # High Intensity backgrounds
   On_IBlack='\e[0;100m'   # Black
     On_IRed='\e[0;101m'     # Red
   On_IGreen='\e[0;102m'   # Green
  On_IYellow='\e[0;103m'  # Yellow
    On_IBlue='\e[0;104m'    # Blue
  On_IPurple='\e[0;105m'  # Purple
    On_ICyan='\e[0;106m'    # Cyan
   On_IWhite='\e[0;107m'   # White

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

export GREEN_UL="\033[4;32m"
