#!/usr/bin/env expect -d

# This test works thanks to the following tricks...
# - Set PS1 environment variable to the empty string in order to remove the prompt.
# - Then, send 2 easily identifiable commands, "echo A\n" and "echo B\n" that we 
#   can easily regexmatch, when concatenated with an ANSI escape characters sequence.
# - As tmux-gitbar adds its update-gitbar script to bash PROMPT_COMMAND environment, 
#   it gets executed each time (just before) bash normally displays a prompt.
# - We now have the exact ANSI character sequence sent by the terminal emulator (tmux
#   in our case) during the execution of both echo's
# This script tests that update-gitbar does not output nothing to stdout (directly or
# just passing through tmux errors or garbage)

source ./test/integration-tests/helpers/expect_setup.tcl

# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1

log_user 1

# Disable prompt and clear screen, leaving the screen totally blank and adding nothing
# more than an ANSI escape sequence between 2 command executed by the prompt.
send "PS1=''"
sleep 0.5
clear_screen

# Send 2 easily identifiable commands
send "echo A"
send "echo B"

# ANSI control character sequence
set ansi {\x1b\(B\x1b\[m\x1b\[K\x0d\x0a\x1b\[37m}

# Forge the total ANSI sequence we expect to see. If tmux does not understand
# some of the commands we send during the execution of our update_gitbar function, 
# installed in the PROMPT_COMMAND, we will get some error output in between.
set str {echo A}
append str $ansi
append str "A"
append str $ansi
append str "echo B"
append str $ansi
append str "B"

# As tmux started in-tree, expect to see the branch name
assert_on_screen_regex $str "No output is produced by tmux-gitbar prompt command"

## End of test: success!
teardown_and_exit
