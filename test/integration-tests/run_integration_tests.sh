#!/usr/bin/env bash

ROOT_DIR="${1}"
export TMUXCONF="${ROOT_DIR}/tmux.conf"

# create and fill tmux conf file
touch  "${TMUXCONF}"
echo TMUX_GITBAR_DIR=\"$ROOT_DIR\" >> "${TMUXCONF}"
echo source-file \"$ROOT_DIR/tmux-gitbar.tmux\" >> "${TMUXCONF}"

bats test/integration-tests/*.bats
