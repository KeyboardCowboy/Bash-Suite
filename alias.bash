#!/usr/bin/env bash
# ALIASES
alias b="cd -"
alias bcw='bundle exec compass watch'
alias bcc='bundle exec compass compile'
alias bi='bundle install'
alias bu='bundle update'
alias cc="drush cc all"
alias cdg="cd \$(git rev-parse --show-toplevel 2> /dev/null) || ."
alias cp="cp -r"
alias d="drush -y"
alias devcheck="grep 'kpr' .;grep 'dpm' .;grep 'console.log' .;"
alias drsuh="drush"
alias dsc="drush dslm-switch-core"
alias duli="drush @self uli"
alias e='edit';
alias flushcache='dscacheutil -flushcache'
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gr="git remote -v"
alias grep='grep -rn'
alias gs="git status"
alias hideSystemFiles="defaults write com.apple.Finder AppleShowAllFiles NO;killall Finder;"
alias hpr="hub pull-request -o -m"
alias j="jekyll"
alias jsl="bundle exec jekyll s --config=_config.yml,_config-local.yml"
alias kopen="open -a 'Komodo Edit'"
alias kotools="cd ~/Library/Application\ Support/KomodoEdit/8.5/tools"
alias ll='decho;echo -e "${SYSCOLOR}"`pwd`"${RESET}";ls -ahl;echo -e "${SYSCOLOR}"`pwd`"${RESET}";decho;'
alias lls='decho;echo -e "${SYSCOLOR}"`pwd`"${RESET}";ls -ahlS;echo -e "${SYSCOLOR}"`pwd`"${RESET}";decho;'
alias logs='cd /Applications/MAMP/logs'
alias mkdir="mkdir -p"
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias notify="terminal-notifier"
alias p="cd ..; ll"
alias ping='ping -c 5'
alias rebash="source ~/.bash_profile"
alias settings="cp sites/default/default.settings.php sites/default/settings.php"
alias showSystemFiles="defaults write com.apple.Finder AppleShowAllFiles YES;killall Finder;"
alias themeon="drush -y en devel_themer"
alias themeoff="drush -y dis devel_themer"
alias web="cd $WEBROOT"
alias wget="wget --no-check-certificate"
