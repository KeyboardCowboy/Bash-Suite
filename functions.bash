#!/bin/sh
# functions.inc
# Include all function files.

for f in ~/.bash_config/global/func/*.bash; do
  if [ -f $f ]; then
    source $f
  fi
done

