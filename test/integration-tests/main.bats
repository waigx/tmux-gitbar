#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"

setup() {
  create_test_repo
  backup_pwd
}

@test "behaviour in and out of git working tree" {
  expect "${BATS_TEST_DIRNAME}/in_and_out_of_working_tree.tcl"
}

teardown() {
  restore_pwd
  cleanup_test_repo
}
