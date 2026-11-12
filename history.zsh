# History settings. zsh-only; sourced from interactive.bash.
# Runs after /etc/zshrc, which sets HISTFILE and the small defaults (2000/1000).

HISTSIZE=100000            # lines kept in memory per session
SAVEHIST=100000            # lines kept in ~/.zsh_history

setopt EXTENDED_HISTORY    # record timestamp + duration for each command
setopt INC_APPEND_HISTORY  # write each command immediately (not at exit)
setopt HIST_IGNORE_SPACE   # a command starting with a space is never saved
setopt HIST_IGNORE_DUPS    # skip a command identical to the previous one
setopt HIST_VERIFY         # show !!, !$ expansions for review before running
setopt HIST_REDUCE_BLANKS  # trim extra whitespace before saving
