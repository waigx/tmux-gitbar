#!/usr/bin/env bash

ROOT_DIR="${1}"
export TMUXCONF="${ROOT_DIR}/tmux.conf"

# Create a minimal tmux conf file
> "${TMUXCONF}"
echo TMUX_GITBAR_DIR=\"$ROOT_DIR\" >> "${TMUXCONF}"
echo source-file \"$ROOT_DIR/tmux-gitbar.tmux\" >> "${TMUXCONF}"
echo set-option -g status-right \"[out of working tree]\" >> "${TMUXCONF}"

bats test/integration-tests/*.bats
