#!/bin/bash
#
# drush.cfg
#
# DRUSH SPECIFIC SETTINGS AND FUNCTIONS

# Quick directory change for drush
function cdd {
  # Derrive the path
  GO=$(_dd $1 $2);

  # Make sure we have a legit path before we try to change dir.
  if [ -n "$GO" ] && [ -d $GO ]; then
    cd $GO
  fi
}

# Helper function to resolve a directory using drush.
function _dd {
  GO='';

  if [ -z $1 ]; then
    GO=`drush dd`
  elif [ -n $1 ] && [ -z $2 ]; then
    GO=`drush dd $1`
  #elif [ -n $1 ] && [ -z $2 ] && [ ${1:0:1} == "@" ]; then
    #GO=`drush $1 dd`
  elif [ -n $1 ] && [ -n $2 ] && [ ${1:0:1} == "@" ]; then
    GO=`drush $1 dd $2`
  fi

  echo $GO;
}

# Use Drush to download and install a module
function di () {
    MOD=$1
    drush dl $MOD
    drush en -y $MOD
}

# Drush reinstallation procedure.
function drin () {
    MOD=$1
    drush -y dis $MOD
    drush -y pm-uninstall $MOD
    drush -y en $MOD
}

# Completely uninstall and remove a module
function drm() {
    MOD=$1
    echo -n "This will completely disable, uninstall and remove the module '$MOD'.  Do you want to continue (y/n)? "
    read CONT

    if [ "$CONT" == "y" ]; then
        drush -y dis $MOD
        drush -y pm-uninstall $MOD
        rm -rf `drush dd $MOD`
    fi
}

# Open a module or theme in a finder window
function dopen {
  DIR=$(_dd $1 $2);
  open $DIR;
}

# Create a new Drupal 7 site with default credentials.
function newD7() {
  SITENAME=$1

  if [ -n "$SITENAME" ]; then
    echo -n "This will install a new Drupal 7 site in '`pwd`/$SITENAME'.  Do you want to continue (y/n)? "
    read CONT

    if [ "$CONT" == "y" ]; then
      # Create the site
      drush dl -y --drupal-project-rename=$SITENAME drupal-7
      cd $SITENAME
      drush si minimal -y --db-url=mysqli://$MYSQL_USER:$MYSQL_PASS@localhost/$SITENAME --site-name=$SITENAME

      # Set permissions
      #WebPerm

      # Set up the necessary directories
      mkdir -p sites/all/modules/libraries
      mkdir -p sites/all/modules/custom sites/all/modules/contrib
      mkdir -p sites/all/themes/custom sites/all/themes/contrib
    fi
  else
    echo "Specify a site name."
  fi
}

# Safely get the current drush version.
#
# We could use `drush --version --pipe` but it required bootstrapping drush
#   which is too expensive for things like a bash prompt.
function drush_version {
  $(require_command drush) || exit 1

  # Get the path to the actual drush command.
  DRUSH_PATH=`command -v drush`
  DRUSH_PATH=`readlink -f $DRUSH_PATH`".info"

  # Trim the version out of the info file.
  VERSION=`cat $DRUSH_PATH`
  VERSION=${VERSION#drush_version=}

  echo "$VERSION"
}
