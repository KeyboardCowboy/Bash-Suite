#!/bin/bash
# COPY THIS FILE TO YOUR CUSTOM DIRECTORY AND MAKE ANY CHANGES THERE!

# Import color definitions
source ~/.bash_config/global/colors.inc

# Set the terminal title to the hostname
export TITLE=`hostname`
export STITLE=`hostname`

export PATH=$PATH:~/.bash_config/global/bin:~/.bash_config/local/bin

export APACHE_CONFIG_PATH=
export HOSTS_PATH=

export MYSQL_USER=
export MYSQL_PASS=

export APACHE_USER=
export APACHE_GROUP=

export SVN_BASH_REPO=
export SVN_REPO=

export WEBROOT=/
