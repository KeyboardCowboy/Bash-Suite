#!/bin/bash
#
# Load the system bashrc file
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# Load environment variables
if [ -f ~/.bash_config/vars.inc ]; then
  source ~/.bash_config/vars.inc
fi

# Load our global settings
for f in ~/.bash_config/global/*.cfg; do
  #echo "LOADING: $f"
  if [ -f $f ]; then
    source $f
  fi
done

# Load our custom settings
for f in ~/.bash_config/local/*.cfg; do
  if [ -f $f ]; then
    source $f
  fi
done

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
