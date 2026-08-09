#!/usr/bin/env bash

pkill "AeroSpace"
pkill "sketchybar"

# small delay to ensure clean shutdown
sleep 0.2

# Relaunch AeroSpace detached from the terminal
open -na "AeroSpace"
