#!/bin/bash
#
# drupal.cfg
# DRUPAL SPECIFIC SETTINGS AND FUNCTIONS

##
# Open a changelog for editing.
##
function cl {
  if [ -f "sites/default/settings.php" ]; then
    FILE="sites/default/CHANGELOG.txt"
  else
    FILE="CHANGELOG.txt"
  fi

  touch $FILE
  edit $FILE
}