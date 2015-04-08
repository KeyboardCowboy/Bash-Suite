#!/bin/bash

# Import color definitions
source ~/.bash_config/global/colors.bash

# Set the system prompt color
# BLACK | RED | GREEN | YELLOW | BLUE | VIOLET | CYAN | WHITE
export SYSCOLOR=$(color CYAN)

# Set the terminal short and long titles
export TITLE=''
export STITLE=''

# Define the webroot
export WEBROOT=/Users/Chris/www/htdocs

# Add our custom paths
export PATH=$PATH:~/.bash_config/global/bin:~/.bash_config/local/bin

# Add any custom vars here
