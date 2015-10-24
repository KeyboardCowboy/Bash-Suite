#!/bin/bash
#
# Load the system bashrc file
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# Load environment variables
source ~/.bash_config/vars.bash

# Import color definitions and special characters
source ~/.bash_config/global/colors.bash
source ~/.bash_config/global/characters.bash

# Load our global aliases and functions
source ~/.bash_config/global/alias.bash
source ~/.bash_config/global/functions.bash

# Load our custom aliases and functions
if [ -f ~/.bash_config/local/alias.bash ]; then
  source ~/.bash_config/local/alias.bash
fi
if [ -f ~/.bash_config/local/functions.bash ]; then
  source ~/.bash_config/local/functions.bash
fi

# Initialize the console
source ~/.bash_config/global/init.bash
if [ -f ~/.bash_config/local/init.bash ]; then
  source ~/.bash_config/local/init.bash
fi
