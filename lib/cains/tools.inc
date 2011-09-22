# File: tools.inc
# Author: Chris Albrecht
# Description: Cains Installer tool functions.

##
# Ensure a variable is set and open the vars file if not.
##
function cains_checkvar() {
  VAR=$1
  VAL=${!1}

  if [ -z "$VAL" ]; then
    read -p "$PRE Missing variable $VAR. Press any key to continue. " X
    vi ~/.bash_config/vars.inc
    exit 1
  fi
}
