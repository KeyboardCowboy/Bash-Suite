# File: tools.inc
# Author: Chris Albrecht
# Description: Various global tools for bash functionality.

##
# Add a comment to a changelog file
#
function add_changelog_comment() {
  CL=$1

  # Make sure we are in a root to write a changelog entry.
  drupal_req_site_or_module_root

  # Add a line to the changelog.
  if [ -f "sites/default/settings.php" ]; then
    FILE="sites/default/CHANGELOG.txt"
  else
    FILE="CHANGELOG.txt"
  fi

  # Make sure the file exists.
  touch $FILE

  # Add the new lines to the file.
  echo -e $CL | cat - $FILE > .tmpCL && mv .tmpCL $FILE
  echo $FILE
}

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
# Get a consistent datestamp.
#
function datestamp() {
  echo $(date +%Y-%b-%d\ %H:%M:%S)
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

################################################################################
# Drupal Tools
################################################################################
##
# Get the name of the drupal module or theme
##
function drupal_get_project_filename() {
  if [ -f *.info ]; then
    NAME=`find . -name *.info`
    NAME=${NAME:2}
    NAME=${NAME%".info"}
    echo $NAME
  else
    echo ${PWD##*/}
  fi
}

##
# Get the name of the drupal module or theme
##
function drupal_get_project_name() {
  if [ -f *.info ]; then
    while read line
    do
      if [ "${line:0:4}" == "name" ]; then
        NAME=${line}
      fi
    done < *.info

    # Strip off the name text so we are left with just the project name
    NAME=${NAME/name = /}
    NAME=${NAME/name=/}
    NAME=${NAME//\"/}
    echo $NAME
  else
    echo ${PWD##*/}
  fi
}

##
# Get the version number of the drupal module or theme
##
function drupal_get_project_version() {
  local VERSION=$(drupal_get_project_version_full)
  VERSION=${VERSION:4}
  echo $VERSION
}

##
# Get the drupal core version of the drupal module or theme
##
function drupal_get_project_version_core() {
  local VERSION=$(drupal_get_project_version_full)
  VERSION=${VERSION:0:3}
  echo $VERSION
}

##
# Get the full version string of the drupal module or theme
##
function drupal_get_project_version_full() {
  if [ -f *.info ]; then
    while read line
    do
      if [ "${line:0:7}" == "version" ]; then
        VERSION=${line}
      fi
    done < *.info

    # Strip off the version text so we are left with just the version number
    VERSION=${VERSION/version = /}
    VERSION=${VERSION/version=/}
    VERSION=${VERSION//\"/}
    echo $VERSION
  fi
}

##
# Get the type of project we're dealing with: project, module, theme or feature.
#
function drupal_get_project_type() {
  local PWD=`pwd`

  # Use the current directory to determine where this project lives
  if [ -f $PWD/sites/default/default.settings.php ]; then
    echo 'project'
  elif [[ $PWD == */themes/* ]]; then
    echo 'theme'
  else
    if [[ $PWD == */modules/custom/features/* ]]; then
      echo 'feature'
    elif [[ $PWD == */modules/* ]]; then
      echo 'module'
    fi
  fi
}

##
# Get the major Drupal version
# REQUIRES DRUSH
##
function drupal_get_version_core() {
  local DRUSH=`which drush`
  if [ -n $DRUSH ]; then
    local V=`drush status drupal-version --pipe`
    echo ${V%.*}.x
  fi
}

##
# Determine if we are in the root directory of a Drupal module or theme.
##
function drupal_req_module_root() {
  if [ ! -f *.info ]; then
    echo "$PRE You must be in a Drupal root directory to run this function."
    exit 1
  fi
}

##
# Determine if we are in the root directory of a Drupal module, theme or site.
##
function drupal_req_site_or_module_root() {
  if [ ! -f *.info ] && [ ! -f "sites/default/default.settings.php" ]; then
    echo "$PRE You must be in either a Drupal project or webroot directory to run this function."
    exit 1
  fi
}

################################################################################
# SVN Tools
################################################################################
##
# Get the current SVN branch
##
function svn_get_current_branch() {
  if [ ! -d .svn ]; then
    exit 1
  fi

  URL=$(svn_get_url)
  if [[ "$URL" == */trunk* ]]; then
    echo 'trunk'
  elif [[ "$URL" == */branches/* ]]; then
    echo $URL | sed -e 's#^'"$(svn_get_url_branches)/"'##g' | sed -e 's#/.*$##g' | awk '{print ""$1"" }'
  fi
}

##
# Get the URL of the directory in the repository
##
function svn_get_url() {
  if [ ! -d .svn ];then
    exit 1
  fi

  URL=`svn info --xml | fgrep "<url>"`

  # Strip the tags
  URL=${URL/<url>/}
  URL=${URL/<\/url>/}

  echo $URL
}

##
# Get the URL to the TRUNK directory for a project
##
function svn_get_url_trunk() {
  # Get the SUBDIR if it was passed
  if [ -n "$1" ]; then
    local SUBDIR="/$1"
  else
    local SUBDIR=""
  fi
  DIR=$(get_normal_url $SUBDIR)
  DIR="$DIR/trunk"
  echo $DIR
}

##
# Get the URL to the BRANCHES directory for a project
##
function svn_get_url_branches() {
  # Get the SUBDIR if it was passed
  if [ -n "$1" ]; then
    local SUBDIR="/$1"
  else
    local SUBDIR=""
  fi

  DIR=$(get_normal_url $SUBDIR)
  DIR="$DIR/branches"
  echo $DIR
}

##
# Get the URL to the TAGS directory for a project
##
function svn_get_url_tags() {
  # Get the SUBDIR if it was passed
  if [ -n "$1" ]; then
    local SUBDIR="/$1"
  else
    local SUBDIR=""
  fi
  DIR=$(get_normal_url $SUBDIR)
  DIR="$DIR/tags"
  echo $DIR
}

##
# Require that the current dir is in svn.
#
function svn_req() {
  if [ ! -d ".svn" ]; then
    echo "$PRE This directory does not appear to be under version control."
    exit 1
  fi
}

##
# Display a list of tags and allow the user to select one, returning the value.
##
function svn_select_tag_version() {
  TAGS=$(svn_get_url_tags)
  if [ -z "$TAGS" ]; then
    echo "$PRE Unable to locate tags directory."
    exit 1
  fi

  # Ask the user for the version to export
  decho
  VERSIONS=`svn list $TAGS`
  VARR=$(echo $VERSIONS | tr " " "\n")
  i=1
  for V in $VARR; do
    V=${V/\//}
    ARR[$i]=$V
    echo "[$i] $V"
    ((i++))
  done
  decho
  read -p "$PRE Select version: " VID

  VERSION=${ARR[$VID]}
  echo $VERSION
}

##
# Get the base URL to a project location in the repo so we can append the proper
# branches/tags/trunk subdirectory
#
function get_normal_url() {
  SUBDIR=$1
  URL=$(svn_get_url)
  DIR=''

  if [[ "$URL" == */trunk$SUBDIR ]]; then
    DIR=${URL//\/trunk*/}
  fi
  if [[ "$URL" == */tags$SUBDIR/* ]]; then
    DIR=${URL//\/tags*/}
  fi
  if [[ "$URL" == */branches$SUBDIR/* ]]; then
    DIR=${URL//\/branches*\/*/}
  fi

  echo $DIR
}

##
# Get the SVN project name and branch.
##
function svn_project_name() {
  local URL=$(get_normal_url)
  if [ -n "$URL" ]; then
    echo "$(basename $(dirname $URL)) ($(svn_get_current_branch))"
  fi
}

################################################################################
# GIT Tools
################################################################################
##
# Are we in a git project?
##
function is_git {
  echo $(git_get_current_branch) || null
}

##
# Get the current GIT branch
##
function git_get_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

##
# Get the project name from custom config keys.
##
function git_project_name {
  if [ $(is_git) ]; then
    local PROJ=`git config --get-all project.name`

    if [ -n "$PROJ" ]; then
      echo "$PROJ"
    else
      echo "No project name. (git config project.name 'Project Name')"
    fi
  fi
}

##
# Get the root directory of this GIT project.
##
function git_root_dir {
  if [ $(is_git) ]; then
    echo $(git rev-parse --show-toplevel)
  fi
}
