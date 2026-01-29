#!/usr/bin/env fish
adb shell dumpsys activity activities | grep -i '* Hist' | grep "$argv[1]"
