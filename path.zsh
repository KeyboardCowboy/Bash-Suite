# PATH for this shell config package. zsh-only (uses zsh's $path array).
#
# The ONE place PATH is built. Sourced from .bash_profile (~/.zprofile),
# which runs AFTER macOS's /etc/zprofile (path_helper) has added the
# system dirs from /etc/paths and /etc/paths.d.
#
# Order matters: the first directory containing a command wins.

# Homebrew's official setup: HOMEBREW_* vars, man/info pages, and zsh
# completions. It also prepends /opt/homebrew/{bin,sbin}; we reorder below.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# zsh ties the $path array to $PATH. -U keeps only the FIRST copy of each
# entry, so listing a dir here moves it to the front and drops duplicates.
typeset -U path PATH

path=(
  ~/.bash_config/local/bin       # per-machine scripts (override global)
  ~/.bash_config/global/bin      # package scripts
  ~/.local/bin                   # uv and other user-installed tools
  /opt/homebrew/bin              # Homebrew (Apple Silicon)
  /opt/homebrew/sbin
  $path                          # system dirs from path_helper (/usr/local/bin
                                 # first: app CLI shims like cursor, dayone)
)

# Machine-specific additions (untracked)
if [[ -f ~/.bash_config/local/path.zsh ]]; then
  source ~/.bash_config/local/path.zsh
fi
