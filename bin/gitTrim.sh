#!/bin/sh
#
# Run through each branch and prompt the user to delete it from the local, a
# remote, or none.

# Load utility functions
source ~/.bash_config/global/functions.bash

if [ $(is_git) ]; then
  echo "Which do you want to delete?"

  for BRANCH in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    ACTION=''
    P=`echo "${YELLOW}$BRANCH${RESET}: ${CYAN}(l)${RESET}ocal ${CYAN}(o)${RESET}rigin, ${CYAN}(s)${RESET}kip, ${CYAN}(e)${RESET}xit: "`

    while [[ "$ACTION" != "l" ]] && [[ "$ACTION" != "o" ]] && [[ "$ACTION" != "s" ]] && [[ "$ACTION" != "e" ]]; do
      read -p "$P" ACTION
    done

    case $ACTION in
      'l')
        git branch -D $BRANCH;;

      'o')
        git push origin --delete $BRANCH
        git branch -D $BRANCH;;

      's')
        echo 'skipped...';;

      'e')
        echo 'exiting...';
        exit 1;;
    esac
  done
fi
