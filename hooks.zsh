# Shell hooks. zsh-only; sourced from interactive.bash.
#   chpwd:  after any directory change, list it with ll.
#   precmd: before each prompt, set the terminal tab title to "host: dir".

autoload -Uz add-zsh-hook

# After any directory change (cd, cd -, pushd/popd, web, cdb, mkd -d),
# list the new directory's contents with ll (func/base.bash).

_bash_config_list_dir() {
  # Only when output goes to a terminal, so $(cd somewhere; pwd) and
  # pipes aren't polluted with a listing.
  [[ -t 1 ]] && ll
}

add-zsh-hook chpwd _bash_config_list_dir

# Tab title = "my-mac: projects", so every tab names its machine at a glance.
# Runs before each prompt, so after `exit` from an SSH session the local
# shell puts its own host back. (The remote machine sets the title while
# you're on it, so it needs this config too.)
_bash_config_tab_title() {
  [[ -t 1 ]] || return 0
  # print -P expands prompt escapes: %m = hostname up to the first dot,
  # %1~ = current directory's last part (~ for home).
  # \e]1;…\a is the xterm "OSC 1" sequence: set the tab (icon) title.
  print -Pn -- '\e]1;%m: %1~\a'
}

add-zsh-hook precmd _bash_config_tab_title
