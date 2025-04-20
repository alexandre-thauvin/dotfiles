# env vars
$env.M2_HOME = $'($env.PWD)/work/apache-maven-3.9.7'
$env.ANDROID_HOME = '/Applications/Android Studio.app/Contents'
$env.JAVA_HOME = ^/usr/libexec/java_home -v 17 | str trim


# PATH
use std/util "path add"
path add "~/dotfiles/scripts" "/opt/homebrew/bin" $"($env.ANDROID_HOME)/tools" $"($env.ANDROID_HOME)/tools/bin" $"($env.ANDROID_HOME)/platform-tools" $"($env.ANDROID_HOME)/emulator" "/opt" $"($env.M2_HOME)" "scripts" "/opt/android-studio/bin" "/usr/local/share/dotnet" "/usr/local/share"

# aliases
alias grep = grep --color
alias shutdown = systemctl poweroff -i
alias ne = emacs
alias dlt = ~/scripts/mr_clean
alias ts = /bin/bash ~/work/swissquote/timesheet/ts.sh
alias tsc = ts continue
alias tse = ts stop
alias tsl = ts lunch
alias tsp = ts push
alias tsr = ts report
alias tss = ts start

# functions
def tssup [hour] { ts start hours eb71b25fb54f1000fc322951351d0000 Support }
def tssbusiness [hour] { ts start hour 37d365e8f24710013b4a632bd2f90001 Development }
def tsscommunity [hour] { ts start hour 3515c2a1ff2110015b2c1c322a140000 community }

# open VS code for given file
def code [file] {
^open -a "Visual Studio Code" $file
}

# keybinding
stty intr '^E'

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")