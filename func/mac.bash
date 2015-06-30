#!/bin/bash
#
# mac.cfg
# MAC SPECIFIC SETTINGS AND FUNCTIONS

ME=`whoami`

# Copy something to the clipboard
function copy() {
  echo "$1" | pbcopy
  echo "Copied"
}

# Add a spacer to the dock
function DockSpacer() {
  defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
  killall Dock
}

# Paste the contents of the clipboard into a file
function pf() {
  pbpaste > $1
}

function openweb {
  case $1 in
    'dop')
      open http://drupal.org/project/$2;;
  esac
}
# Reset Quicksilver if results start getting wonky
#function resetQS() {
#
#}
