#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "helpers/tmux_bats_helpers"

setup() {
  restore_tmgb_conf
  create_test_repo
  backup_pwd
}

@test "behaviour in and out of git working tree" {
  set_option_in_tmux_conf 'status-right' '[out of working tree]'
  expect "${BATS_TEST_DIRNAME}/in_and_out_of_working_tree.tcl"
}

@test "tmux-gitbar can show on the left" {

  set_tmgb_location_left
  set_option_in_tmux_conf 'status-left' '[out of working tree]'
  set_option_in_tmux_conf 'status-right' '[right]'
  expect -d "${BATS_TEST_DIRNAME}/tmux-gitbar_location.tcl" -- left
}

@test "tmux-gitbar can show on the right" {

  # Default tmux-gitbar location is on the right
  set_option_in_tmux_conf 'status-right' '[out of working tree]'
  set_option_in_tmux_conf 'status-left' '[left]'
  expect "${BATS_TEST_DIRNAME}/tmux-gitbar_location.tcl" -- right
}

teardown() {
  restore_pwd
  cleanup_test_repo
  restore_tmgb_conf
}
