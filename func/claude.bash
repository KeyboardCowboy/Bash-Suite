#!/usr/bin/env bash
#
# claude.bash
# Helpers for Claude Code (the `claude` CLI).

##
# ccn: start Claude Code with a named session.
#
# While Claude Code runs it owns the terminal tab title, and an unnamed
# session gets a generated title that's often too vague to tell tabs apart.
# A named session shows its name in the tab instead (claude -n / --name).
#
#   ccn                    -> claude -n <current folder>
#   ccn auth-bug           -> claude -n auth-bug
#   ccn auth-bug --model X -> extra args are passed through to claude
#   ccn --model X          -> first arg is a flag, so the folder name is used
#
# Over SSH the host is prefixed ("my-mini:projects"), since the tab title
# no longer shows which machine you're on while Claude is running.
#
# A separate command on purpose, not a wrapper around `claude`: subcommands
# like `claude agents` or `claude --resume` must stay untouched.
##
function ccn() {
  local name

  # Use $1 as the name unless it's missing or looks like a flag (-x / --x).
  if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then
    name=$1
    shift
  else
    # ${PWD##*/} strips everything up to the last "/" (the folder name);
    # fall back to "root" for "/" where that's empty.
    name=${PWD##*/}
    name=${name:-root}
  fi

  if [ -n "${SSH_CONNECTION:-}" ]; then
    name="$(hostname -s):$name"
  fi

  # `command` skips any alias/function named claude and runs the real CLI.
  command claude -n "$name" "$@"
}
