#!/usr/bin/env bash
#
# Interactive shell setup: aliases and functions.
#
# Sourced from ~/.zshrc, so it runs in EVERY interactive shell (login or
# not). Environment variables and PATH stay in .bash_profile (~/.zprofile).

# The `color` helper is a function, and functions are never inherited from
# a parent shell, so load it here instead of relying on .zprofile.
source ~/.bash_config/global/colors.bash

# zsh-only: history settings, and zmv for bulk renames
#   zmv '(*).txt' '$1.md'     (use `zmv -n …` to preview first)
if [ -n "$ZSH_VERSION" ]; then
  source ~/.bash_config/global/history.zsh
  autoload -Uz zmv
fi

# Global aliases and functions
source ~/.bash_config/global/alias.bash
source ~/.bash_config/global/functions.bash

# Per-machine aliases and functions (untracked)
if [ -f ~/.bash_config/local/alias.bash ]; then
  source ~/.bash_config/local/alias.bash
fi
if [ -f ~/.bash_config/local/functions.bash ]; then
  source ~/.bash_config/local/functions.bash
fi
