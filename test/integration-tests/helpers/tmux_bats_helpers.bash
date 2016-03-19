#!/usr/bin/env bash

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

# helpers functions for bats integration tests

# Append a 'set-option' cmd to tmux.conf
set_option_in_tmux_conf() {
  option="$1"
  value="$2"
  echo set-option -g "'$option'" "'$value'" >> "${TMUXCONF}"
}

# Modify TMGB_STATUS_LOCATION variable in-place
set_tmgb_location_left() {

  TMGBCONF="$PWD/tmux-gitbar.conf"
  # In-place modification of tmux-gitbar.conf
  ed -s $TMGBCONF <<< $',s/\(TMGB_STATUS_LOCATION\)=.*/\\1=\'left\'\nw' > /dev/null
}

# Restore the default tmux-gitbar.conf
restore_tmgb_conf() {
  echo '' > /dev/null
  git checkout tmux-gitbar.conf
}
