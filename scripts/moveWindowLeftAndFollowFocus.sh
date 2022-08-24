#!/opt/homebrew/bin/fish
# curWindowId="$(jq -re ".id" <<<$(yabai -m query --windows --window))"
set xx $(yabai -m query --windows --window)
set curWindowId "$(echo $xx | jq -re ".id")"

yabai -m window --display prev || yabai -m window --display last
yabai -m window --focus $argv[1] "$curWindowId"
