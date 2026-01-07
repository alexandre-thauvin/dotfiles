#!/usr/bin/env nu

let aerospace_app_name = "AeroSpace"

def kill_if_running [process_name: string] {
    ps
    | where name =~ $process_name
    | get pid
    | each { |pid| kill -9 $pid }
}

kill_if_running "AeroSpace"
kill_if_running "sketchybar"

# small delay to ensure clean shutdown
sleep 200ms

# Relaunch AeroSpace detached from the terminal
^open -na $aerospace_app_name
