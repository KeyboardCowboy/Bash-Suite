# ALIASES
alias b="cd -"
alias cc="drush cc all"
alias conf="cd /var/www/conf"
alias cp="cp -r"
alias d="drush -y"
alias devcheck="grep 'kpr' .;grep 'dpm' .;grep 'console.log' .;"
alias drsuh="drush"
alias dsc="drush dslm-switch-core"
alias e='edit';
alias flushcache='dscacheutil -flushcache'
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gitname="git config project.name"
alias gl="git log"
alias gr="git remote -v"
alias grep='grep --exclude=*svn* -rn'
alias gs="git status"
alias hideSystemFiles="defaults write com.apple.Finder AppleShowAllFiles NO;killall Finder;"
alias howbigis="sudo du -sh"
alias j="jekyll"
alias kopen="open -a 'Komodo Edit'"
alias kotools="cd ~/Library/Application\ Support/KomodoEdit/8.5/tools"
alias l='decho;echo -e "${SYSCOLOR}"`pwd`"${RESET}";ls -ahl;echo -e "${SYSCOLOR}"`pwd`"${RESET}";decho;'
alias logs='cd /Applications/MAMP/logs'
alias mkdir="mkdir -p"
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias nomode="git config core.filemode false"
alias p="cd ..; l"
alias ping='ping -c 5'
alias rebash="source ~/.bash_profile"
alias settings="cp sites/default/default.settings.php sites/default/settings.php"
alias showAllFiles="defaults write com.apple.Finder AppleShowAllFiles YES;killall Finder;"
alias themeon="drush -y en devel_themer"
alias themeoff="drush -y dis devel_themer"
alias web="cd $WEBROOT"
alias wget="wget --no-check-certificate"
