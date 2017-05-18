#!/bin/bash
#
# mac.cfg
# MAC SPECIFIC SETTINGS AND FUNCTIONS

ME=`whoami`

function openweb {
  case $1 in
    'dop')
      open http://drupal.org/project/$2;;
  esac
}

##
# Restart the Syslog service.
# Verified on OSX Sierra
##
function restartSyslog {
  sudo launchctl unload /System/Library/LaunchDaemons/com.apple.syslogd.plist
  sudo launchctl load /System/Library/LaunchDaemons/com.apple.syslogd.plist
}
