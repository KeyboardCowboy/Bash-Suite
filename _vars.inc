#!/bin/bash
# COPY THIS FILE TO YOUR CUSTOM DIRECTORY AND MAKE ANY CHANGES THERE!

# Import color definitions
source ~/.bash_config/global/colors.inc

# Set the system prompt color
export SYSCOLOR=$(color CYAN)

# Set the terminal title
export TITLE=`hostname`
export STITLE=`hostname`

export PATH=$PATH:~/.bash_config/global/bin:~/.bash_config/local/bin

export APACHE_USER=
export APACHE_GROUP=
export DEFAULT_SITE_ADMIN=
export SKIP_PERM_CHECK=0

export MYSQL_USER=
export MYSQL_PASS=

export SVN_BASH_REPO=
export SVN_REPO=

export WEBROOT=/
