# expect setup
set this_dir [file dirname [file normalize [info script]]]

source $this_dir/expect_helpers.tcl
source $this_dir/tmux_helpers.tcl

expect_setup

# exit status global var is successful by default
set exit_status 0
