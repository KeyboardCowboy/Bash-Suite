#!/bin/bash

# Import color definitions
source ~/.bash_config/global/colors.bash

# Set the system prompt color
# BLACK | RED | GREEN | YELLOW | BLUE | VIOLET | CYAN | WHITE
SYSCOLOR=$(color CYAN)
export SYSCOLOR

# Set the terminal short and long titles
export TITLE=''
export STITLE=''

# Define the webroot
export WEBROOT=~/www/htdocs
