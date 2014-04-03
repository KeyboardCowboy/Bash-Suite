# functions.inc
# Include all function files.

for f in ~/.bash_config/global/func/*.inc; do
  if [ -f $f ]; then
    source $f
  fi
done
