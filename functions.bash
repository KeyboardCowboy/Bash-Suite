#!/usr/bin/env bash
# functions.bash
# Load every function file in global/func/.

for _bash_config_f in ~/.bash_config/global/func/*.bash; do
  if [ -f "$_bash_config_f" ]; then
    source "$_bash_config_f"
  fi
done
unset _bash_config_f
