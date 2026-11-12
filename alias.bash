#!/usr/bin/env bash
# ALIASES
alias b="cd -"
alias cdg="cd \$(git rev-parse --show-toplevel 2> /dev/null) || ."
alias devcheck='grep -rnE "kpr\(|dpm\(|console\.log" --exclude-dir={vendor,node_modules,.git} .'
alias flushcache='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gr="git remote -v"
alias gs="git status"
alias hideSystemFiles="defaults write com.apple.Finder AppleShowAllFiles NO;killall Finder;"
alias hpr='gh pr create --web'
alias ll='decho;echo -e "${SYSCOLOR}"`pwd`"${RESET}";ls -ahl;echo -e "${SYSCOLOR}"`pwd`"${RESET}";decho;'
alias lls='decho;echo -e "${SYSCOLOR}"`pwd`"${RESET}";ls -ahlS;echo -e "${SYSCOLOR}"`pwd`"${RESET}";decho;'
alias mkdir="mkdir -p"
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias p="cd .."
alias ping='ping -c 5'
alias rebash="exec zsh -l"
alias rekey="ssh-keygen -t ed25519 -a 100"
alias say="say -v Samantha"
alias showSystemFiles="defaults write com.apple.Finder AppleShowAllFiles YES;killall Finder;"
alias web='cd "$WEBROOT"'
