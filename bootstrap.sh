#!/usr/bin/env bash
#
# bootstrap.sh: wire a Mac up to this shell config package.
#
# Run once on a new machine after cloning this repo to ~/.bash_config/global:
#
#   ~/.bash_config/global/bootstrap.sh --dry-run   # preview, changes nothing
#   ~/.bash_config/global/bootstrap.sh             # do it
#
# What it sets up (the load chain this package expects):
#
#   ~/.zprofile ──symlink──▶ ~/.bash_config/global/.bash_profile
#   ~/.vimrc    ──symlink──▶ ~/.bash_config/global/.vimrc
#   ~/.zshrc    (real file) ends with: source ~/.bash_config/global/interactive.bash
#   ~/.bash_config/vars.bash  (copied from _vars.bash; untracked, per-machine)
#
# Safety rules:
#   - Idempotent: anything already correct is left alone, so re-running is safe.
#   - Anything it replaces or edits is first copied to
#     ~/.bash_config_backups/bootstrap-<timestamp>/.
#   - It never installs software. Missing prerequisites (Homebrew, starship,
#     the icon font) are reported with the command to run.
#
# Written for macOS's stock /bin/bash 3.2 (no associative arrays, no mapfile),
# because it runs before anything else is set up.

set -eu   # -e: stop on the first failed command; -u: unset variables are errors

CONFIG_DIR="$HOME/.bash_config"
REPO_DIR="$CONFIG_DIR/global"
SOURCE_LINE='source ~/.bash_config/global/interactive.bash'

DRY_RUN=0
BACKUP_DIR=""     # created lazily by backup(), only if something needs backing up
CHANGES=0         # count of changes made (or that would be made, in dry-run)

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

main() {
  parse_args "$@"
  check_location
  if [ "$DRY_RUN" -eq 1 ]; then
    say "DRY RUN: nothing will be changed."
  fi

  ensure_vars_file
  ensure_symlink "$HOME/.zprofile" "$REPO_DIR/.bash_profile"
  ensure_symlink "$HOME/.vimrc"    "$REPO_DIR/.vimrc"
  ensure_zshrc
  check_prereqs

  summary
}

# ---------------------------------------------------------------------------
# Setup steps
# ---------------------------------------------------------------------------

##
# Refuse to run unless this script lives at ~/.bash_config/global, since every
# file in the package hardcodes that path.
##
check_location() {
  local script_dir
  # BASH_SOURCE[0] is this file's path even when called via a relative path;
  # `pwd -P` resolves symlinks so the comparison below is reliable.
  script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)

  # -ef: true if both paths point to the same directory on disk.
  if [ ! "$script_dir" -ef "$REPO_DIR" ]; then
    fail "This repo must be cloned to $REPO_DIR (it is at $script_dir)."
  fi
  if [ "$(id -u)" -eq 0 ]; then
    fail "Run this as your normal user, not root/sudo."
  fi
}

##
# vars.bash is untracked and per-machine. .bash_profile sources it
# unconditionally, so it must exist. Create it from the tracked template if
# it's missing; never touch an existing one.
##
ensure_vars_file() {
  local target="$CONFIG_DIR/vars.bash"
  if [ -e "$target" ]; then
    ok "vars.bash exists (left as-is)"
  else
    act "create vars.bash from _vars.bash template"
    run cp "$REPO_DIR/_vars.bash" "$target"
  fi
}

##
# Make LINK a symlink pointing at TARGET, backing up whatever was there.
##
ensure_symlink() {
  local link=$1 target=$2 name
  name=$(basename "$link")

  # -L: is a symlink; -ef: resolves to the same file as TARGET. Both true
  # means it's already correct, whether the link was written as relative or
  # absolute.
  if [ -L "$link" ] && [ "$link" -ef "$target" ]; then
    ok "$name already links to the repo"
    return
  fi

  # -e is false for a dangling symlink, so check -L as well.
  if [ -e "$link" ] || [ -L "$link" ]; then
    backup "$link"
    warn "$name exists and gets replaced. Review the backup for anything worth"
    warn "  keeping (e.g. a 'brew shellenv' line: path.zsh already does that)."
  fi
  act "link $name -> $target"
  # -s symbolic, -f replace existing, -n don't descend into a linked directory
  run ln -sfn "$target" "$link"
}

##
# ~/.zshrc stays a real, untracked file: installers (nvm, ddev, etc.) like to
# append to it, and that per-machine noise shouldn't land in this public repo.
# Make sure it sources interactive.bash, ideally as the last line.
##
ensure_zshrc() {
  local zshrc="$HOME/.zshrc" last_line

  if [ ! -e "$zshrc" ]; then
    act "create .zshrc that sources interactive.bash"
    run_write "$zshrc" "# Shell config package: aliases & functions (~/.bash_config)
$SOURCE_LINE"
    return
  fi

  # grep -x matches whole lines only, -F treats the pattern as plain text.
  if grep -qxF "$SOURCE_LINE" "$zshrc"; then
    # Last non-blank line: the package should load after anything else in
    # .zshrc so its aliases win.
    last_line=$(grep -v '^[[:space:]]*$' "$zshrc" | tail -n 1)
    if [ "$last_line" = "$SOURCE_LINE" ]; then
      ok ".zshrc already sources interactive.bash"
    else
      warn ".zshrc sources interactive.bash, but not as the last line."
      warn "  Lines after it can override package aliases. Move it to the end."
    fi
    return
  fi

  backup "$zshrc"
  act "append the interactive.bash source line to .zshrc"
  run_append "$zshrc" "
# Shell config package: aliases & functions (~/.bash_config)
$SOURCE_LINE"
}

##
# Report (never install) things the config uses but can live without.
##
check_prereqs() {
  if [ -x /opt/homebrew/bin/brew ]; then
    ok "Homebrew found at /opt/homebrew"
  else
    warn "Homebrew not at /opt/homebrew. path.zsh expects it there."
    warn "  Install from https://brew.sh, then re-run this script."
  fi

  # Look in Homebrew's bin directly: PATH isn't set up yet in this shell.
  if [ -x /opt/homebrew/bin/starship ]; then
    ok "starship installed"
  else
    warn "starship missing (prompt falls back to zsh default). To install:"
    warn "  brew install --dry-run starship   # check, then drop --dry-run"
  fi

  # `ls` on a glob succeeds only if at least one file matches.
  if ls "$HOME"/Library/Fonts/SymbolsNerdFont* >/dev/null 2>&1; then
    ok "Symbols Nerd Font installed"
  else
    warn "Symbols Nerd Font missing (prompt icons show as boxes). To install:"
    warn "  brew install --dry-run --cask font-symbols-only-nerd-font"
    warn "  Then set iTerm's non-ASCII font to 'Symbols Nerd Font Mono'."
  fi

  if [ "${SHELL:-}" != /bin/zsh ]; then
    warn "Login shell is ${SHELL:-unknown}, not zsh. Fix: chsh -s /bin/zsh"
  fi
}

summary() {
  echo
  if [ "$CHANGES" -eq 0 ]; then
    say "Nothing to do: this machine is already set up."
  elif [ "$DRY_RUN" -eq 1 ]; then
    say "$CHANGES change(s) would be made. Re-run without --dry-run to apply."
  else
    say "$CHANGES change(s) made."
    # `if`, not `[ … ] && …`: a false test as a function's last command would
    # make the whole script exit non-zero even though it succeeded.
    if [ -n "$BACKUP_DIR" ]; then
      say "Backups: $BACKUP_DIR"
    fi
    say "Optional: add per-machine files in $CONFIG_DIR/local/"
    say "  (path.zsh, alias.bash, functions.bash). See CLAUDE.md on your main Mac."
    say "Test:  env -i HOME=\$HOME TERM=xterm zsh -l -i -c 'type ll gp cdb mkd'"
    say "Then:  exec zsh -l"
  fi
}

# ---------------------------------------------------------------------------
# Helpers: argument parsing, dry-run-aware actions, backups, output
# ---------------------------------------------------------------------------

parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      -n|--dry-run) DRY_RUN=1 ;;
      -h|--help)
        # Print the header comment block (lines 2 until the first blank line), minus "# ".
        sed -n '2,/^$/s/^# \{0,1\}//p' "${BASH_SOURCE[0]}"
        exit 0 ;;
      *) fail "Unknown option: $1 (try --help)" ;;
    esac
    shift
  done
}

##
# Every change goes through run / run_write / run_append, so --dry-run is
# handled in one place instead of in each setup step.
##
run() {
  [ "$DRY_RUN" -eq 1 ] && return 0
  "$@"
}

run_write() {   # FILE TEXT: create FILE containing TEXT
  [ "$DRY_RUN" -eq 1 ] && return 0
  printf '%s\n' "$2" > "$1"
}

run_append() {  # FILE TEXT: append TEXT to FILE
  [ "$DRY_RUN" -eq 1 ] && return 0
  printf '%s\n' "$2" >> "$1"
}

##
# Copy FILE into this run's backup folder before it gets changed.
# cp -P copies a symlink as a symlink (it doesn't follow it).
##
backup() {
  local file=$1
  if [ -z "$BACKUP_DIR" ]; then
    BACKUP_DIR="$HOME/.bash_config_backups/bootstrap-$(date +%Y%m%d-%H%M%S)"
    run mkdir -p "$BACKUP_DIR"
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    say "  would backup $file first"
  else
    say "  backup $file -> $BACKUP_DIR/"
  fi
  run cp -P "$file" "$BACKUP_DIR/"
}

# Colors only when writing to a terminal, so piped/logged output stays clean.
if [ -t 1 ]; then
  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'
  C_RED=$'\033[31m';   C_RESET=$'\033[0m'
else
  C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_RED=''; C_RESET=''
fi

say()  { printf '%s\n' "$*"; }
ok()   { printf '%s  ok%s    %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '%s  warn%s  %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
fail() { printf '%s  error%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }
act() {
  CHANGES=$((CHANGES + 1))
  local verb="do"
  [ "$DRY_RUN" -eq 1 ] && verb="would"
  printf '%s  %-5s%s %s\n' "$C_BLUE" "$verb" "$C_RESET" "$*"
}

main "$@"
