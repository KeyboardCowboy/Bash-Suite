#!/bin/bash
#
# Load the system bashrc file
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# Load environment variables
source ~/.bash_config/vars.inc

# Import color definitions
source ~/.bash_config/global/colors.inc

# Load our global aliases and functions
source ~/.bash_config/global/alias.inc
source ~/.bash_config/global/functions.inc

# Load our custom aliases and functions
if [ -f ~/.bash_config/local/alias.inc ]; then
  source ~/.bash_config/local/alias.inc
fi
if [ -f ~/.bash_config/local/functions.inc ]; then
  source ~/.bash_config/local/functions.inc
fi

# Initialize the console
source ~/.bash_config/global/init.inc
if [ -f ~/.bash_config/local/init.inc ]; then
  source ~/.bash_config/local/init.inc
fi
