# Directory-change hook. zsh-only; sourced from interactive.bash.
# After any directory change (cd, cd -, pushd/popd, web, cdb, mkd -d),
# list the new directory's contents.

autoload -Uz add-zsh-hook

_bash_config_list_dir() {
  # Only when output goes to a terminal, so $(cd somewhere; pwd) and
  # pipes aren't polluted with a listing.
  [[ -t 1 ]] && ls -lah
}

add-zsh-hook chpwd _bash_config_list_dir
