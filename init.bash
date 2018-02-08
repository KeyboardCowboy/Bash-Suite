#!/bin/sh
# Global Console settings
#
# These can be overridden in ~/.bash_config/local/init.bash

# Set the command prompt
#export PS1="\[${SYSCOLOR}\][\u\[${WHITE}\]@\[${SYSCOLOR}\]${TITLE}\[${WHITE}\]\[\$(parse_branch)\]\[${WHITE}\]: \W\[${SYSCOLOR}\]]\[${RESET}\]"$'\xe2\x86\x92 $(set_title)'

export PS1=$(set_prompt)

export PROMPT_COMMAND='export ERR=$?'

# Add our bins to the path
export PATH=~/.drush/bin:~/.bash_config/global/bin:~/.bash_config/local/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

