#!/bin/bash
#
# base.cfg
# SYSTEM LEVEL FUNCTIONS

##
# Parse the GIT and SVN branches we may be on
#
function parse_branch {
  local GIT=$(git_get_current_branch) || ''
  #local SVN=$(svn_get_current_branch) || ''
  local GPN=$(git_project_name) || ''
  local BRANCH=''

  if [ -n "$GIT" ]; then
    local BRANCH="${GREEN}$GPN${WHITE}"$'\xE2\x96\xB8'"${GREEN}$GIT${WHITE}"
  fi
  #if [ -n "$SVN" ]; then
  #  if [ -n "$GIT" ]; then
  #    BRANCH="$BRANCH|${YELLOW}$SVN${WHITE}"
  #  else
  #    BRANCH="${YELLOW}$SVN${WHITE}"
  #  fi
  #fi
  if [ -n "$BRANCH" ]; then
    echo -e "($BRANCH${WHITE})"
  fi
}

# Tree climber
function .. {
  [[ -n $1 ]] && DEPTH=$1 || DEPTH=1

  COUNTER=0
  while [ $COUNTER -lt $DEPTH ]; do
    cd ..
    let COUNTER=COUNTER+1
  done
}

# Add the project name to the console title
function set_title {
  title $(git_project_name) || ''
}

# Edit a configuration file or open the bash profile
function bp() {
  DIR=$1
  FILE=$2

  if [ "$DIR" == "vars" ]; then
    e ~/.bash_config/vars.inc
  elif [ "$DIR" == "l" ]; then
    if [ -n "$FILE" ]; then
      e ~/.bash_config/local/$FILE.cfg
    else
      # If no filename was passed, go to the directory
      cd ~/.bash_config/local
    fi
  elif [ "$DIR" == "g" ]; then
    if [ -n "$FILE" ]; then
      e ~/.bash_config/global/$FILE.cfg
    else
      cd ~/.bash_config/global
    fi
  else
    # If the first paramater is not "l" or "g", open the bash_profile
    e ~/.bash_profile
  fi
}

# Reprogram the EDIT function
function edit() {
  FILE=$1

  if [ -n "$FILE" ]; then
    case $(uname) in
      'Darwin')
        open -a "$TEXT_EDITOR" $FILE;;

      *)
        vi $FILE;;
    esac
  else
    _edit
  fi
}

# Helper function to select a file to edit from a list of the directory
function _edit() {
  echo "------------------------"
  pwd

  i=1
  for file in *; do
    files[i]=$file
    echo "$i. $file"
    ((i++))
  done

  files["e"]="EXIT"
  echo "E. EXIT"

  read -p 'Select a file number: ' NUM

  if [ -f ${files[$NUM]} ]; then
    edit ${files[$NUM]}
  fi
}

# Explode a string into an array, like PHP
function explode() {
  DEL=$1
  STR=$2
  ARR=$(echo $STR | tr "$DEL" "\n")
  echo $ARR
}

# Delete a set of files
function fd() {
  read -p "Delete all instances of '$1' in this tree? (y/n) " X
  if [ $X == "y" ]; then
    find . -name '$1' -exec "rm {}" \;
  else
    echo 'Cancelled.'
  fi
}

# Shortcut to edit specific common files
function fedit() {
  case $1 in
    "apache")
      edit $APACHE_CONFIG_FILE;;
    "hosts")
      edit $HOSTS_FILE
  esac
}

# Find files below the current directory
function ff() {
  sudo find . -name "$1" -print
}

# Find files anywhere on the server
function ffall() {
  sudo find / -name "$1" -print
}

# Relative environment display
function ll() {
  local SVN=$(svn_project_name)
  local GIT=$(git_project_name)

  local OUT;
  OUT="PWD: "$(color CYAN)`pwd`$(color RESET)

  if [ -n "$SVN" ]; then
    OUT="$OUT\nSVN: $(color YELLOW)$SVN$(color RESET)"
  fi
  if [ -n "$GIT" ]; then
    OUT="$OUT\nGIT: $(color GREEN)$GIT$(color RESET)"
  fi

  decho
  echo -e $OUT
  decho
}

# Set the console title
function title() {
  if [ -n "$1" ]; then
    echo -en "\033]1;$STITLE: $1\007"
  else
    echo -en "\033]1;$TITLE\007"
  fi
}
