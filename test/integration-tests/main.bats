#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"

setup() {
  create_test_repo
  pushd . > /dev/null
}

@test "show tmux-gitbar when in a git working tree" {
  cd "$MOCKREPO"
  expect "${BATS_TEST_DIRNAME}/expect_gitbar_in_working_tree"
}

@test "do not show tmux-gitbar when out of a git working tree" {
  cd "$MOCKREPO"
  expect "${BATS_TEST_DIRNAME}/expect_no_gitbar_out_of_working_tree"
}

teardown() {
  popd > /dev/null
  cleanup_test_repo
}
