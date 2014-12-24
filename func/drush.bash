#!/bin/bash
#
# drush.cfg
#
# DRUSH SPECIFIC SETTINGS AND FUNCTIONS

# Add my core modules to a drupal installation
function dpac() {
  for PACK in "$@"; do
    case $PACK in
      'base')
        DL="ctools token features context views"
        EN="ctools token features context views context_ui views_ui image list number overlay path taxonomy contextual menu options shortcut"
        ;;

      'admin')
        DL="strongarm devel devel_themer admin_menu admin backup_migrate coder module_filter"
        EN="strongarm devel admin_menu admin backup_migrate admin_menu_toolbar admin_devel coder module_filter"
        ;;

      'seo')
        DL="nodewords globalredirect robotstxt pathauto"
        EN="nodewords globalredirect robotstxt pathauto"
        ;;

      'user')
        DL="email_registration password_policy realname auto_nodetitle page_title"
        EN="email_registration password_policy realname auto_nodetitle page_title"
        ;;

      'content')
        DL="wysiwyg ckeditor_link"
        EN="wysiwyg ckeditor_link"
        svnd get ckeditor
        ;;

      'workflow')
        DL="workbench"
        EN="workbench"
        ;;
    esac
  done

  drush -y dl $DL
  drush -y en $EN
}

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

# Drush enhanced development environment configuration
function dev() {
    echo -n "Running this script will alter the settings of this Drupal install for development.  Do you want to continue (y/n)? "
    read CONT

    if [ "$CONT" == "y" ]; then
        # enable Admin Menu
        drush -y en admin_menu

        # Enable Devel
        drush -y en devel

        # Disable SecurePages
        drush -y dis securepages
        drush -y dis eere_meta

        # turn off performance enhancements
        drush -y vset cache 0
        drush -y vset page_compression 0
        drush -y vset block_cache 0
        drush -y vset preprocess_css 0
        drush -y vset preprocess_js 0
        drush -y vset error_level 1
    else
        echo "Cancelling development alterations."
    fi
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

# Use drush to specify a directory to open with Atom.
function datom {
  DIR=$(_dd $1 $2);
  atom $DIR;
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
      WebPerm

      # Set up the necessary directories
      mkdir -p sites/all/modules/libraries
      mkdir -p sites/all/modules/custom sites/all/modules/contrib
      mkdir -p sites/all/themes/custom sites/all/themes/contrib
    fi
  else
    echo "Specify a site name."
  fi
}
