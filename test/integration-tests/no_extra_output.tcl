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

# TODO: for now $ansi is the exact ANSI char sequence sent by tmux, but it could be
# different on other terminals, as it is on the terminal emulator used on travis-ci worker.
# Anyway, the important is to test that the only chars between echo A, A, echo B and B are:
# - non-printing characters
# - ANSI char sequences
# - but absolutely no other printable characters
#
# For example this is the sequence saw on travis-ci worker:
#
#   echo A\u001b[K\r\nA\u001b[K\r\necho B
#
# this regex should match all ANSI escape sequence:
  #return /[\u001b\u009b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]/g;
# taken from: https://github.com/chalk/ansi-regex/blob/master/index.js
# its javascript regex but...

# ANSI control character sequence
#set ansi {\x1b\(B\x1b\[m\x1b\[K\x0d\x0a\x1b\[37m}
set ansi {(?:[\x1b\x9b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><])*?}
set crlf {(?:\r\n)*}

#00000000  1b 5b 48 1b 5b 32 42 1b  28 0a                    |.[H.[2B.(.|
#1b 5b 32 42 


# Forge the total ANSI sequence we expect to see. If tmux does not understand
# some of the commands we send during the execution of our update_gitbar function, 
# installed in the PROMPT_COMMAND, we will get some error output in between.

set str "echo A"
set nonvisibles "(?:$crlf|$ansi)*?"
append str $nonvisibles
#append str "echo A"
append str "(.*)echo B"
#append str ".*echo A(.*)B"

# As tmux started in-tree, expect to see the branch name
expect {
  -re $str {
    puts "Found: $expect_out(1,string)"

    # write regex match to file
    set fileId [open regex_match.out w]
    #puts  $fileId "expect_out(1,string):"
    puts -nonewline $fileId $expect_out(1,string)
    #puts  $fileId "\n"
    #puts  $fileId "expect_out(2,string):"
    #puts -nonewline $fileId $expect_out(2,string)
    close $fileId

    #exit_status_false
  }
  timeout {
    puts "  Fail"
    exit_status_false
  }
}


#assert_on_screen_regex $ansi "No output is produced by tmux-gitbar prompt command"

## End of test: success!
teardown_and_exit
