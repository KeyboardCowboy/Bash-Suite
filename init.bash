# Global Console settings
#
# These can be overridden in ~/.bash_config/local/init.bash

# Set the command prompt
export PS1="\[${SYSCOLOR}\][\u\[${WHITE}\]@\[${SYSCOLOR}\]${TITLE}\[${WHITE}\]\[\$(parse_branch)\]\[${WHITE}\]: \W\[${SYSCOLOR}\]]\[${RESET}\]"$'\xe2\x86\x92 $(set_title)'
export PROMPT_COMMAND='export ERR=$?'

# Add our bins to the path
export PATH=$PATH:~/.bash_config/global/bin:~/.bash_config/local/bin

# Set the title
title
