#!/bin/bash
#
# Load the system bashrc file
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# Load environment variables
source ~/.bash_config/vars.bash

# Aliases and functions are interactive-only. They load from ~/.zshrc
# via global/interactive.bash, so non-login shells get them too.

# Initialize the console
source ~/.bash_config/global/init.bash
if [ -f ~/.bash_config/local/init.bash ]; then
  source ~/.bash_config/local/init.bash
fi

