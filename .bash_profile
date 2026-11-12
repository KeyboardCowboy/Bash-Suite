#!/bin/bash
#
# Build PATH first (zsh-only; see path.zsh)
source ~/.bash_config/global/path.zsh

# Load environment variables
source ~/.bash_config/vars.bash

# Aliases and functions are interactive-only. They load from ~/.zshrc
# via global/interactive.bash, so non-login shells get them too.

# Optional per-machine login setup (untracked)
if [ -f ~/.bash_config/local/init.bash ]; then
  source ~/.bash_config/local/init.bash
fi

