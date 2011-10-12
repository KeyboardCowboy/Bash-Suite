# File: tools.inc
# Author: Chris Albrecht
# Description: Various global tools for bash functionality.

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

##
# Get the URL of the directory in the repository
##
function svn_get_url() {
  DATA=`svn info --xml`
  local URL=`expr "$DATA" : '.*\(\<url\>.*\</url\>\)'`

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
  local URL=$(svn_get_url)

  if [[ $URL == */trunk$SUBDIR ]]; then
    TRUNK=${URL//\/trunk*/}
    TRUNK="$TRUNK/trunk$SUBDIR"
    echo $TRUNK
  fi
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
  local URL=$(svn_get_url)

  if [[ "$URL" == */trunk$SUBDIR ]]; then
    TAGS=${URL//\/trunk*/}
    TAGS="$TAGS/tags"
    echo $TAGS
  fi
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
