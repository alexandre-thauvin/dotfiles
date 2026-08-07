# env vars
$env.M2_HOME = $'($env.PWD)/work/apache-maven-3.9.7'
$env.ANDROID_HOME = '/Applications/Android Studio.app/Contents'
$env.JAVA_HOME = '/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home'
# only used for SQ/timesheet
$env.TS_HOME_OFFICE = 0
# Jira: the PAT lives in the macOS Keychain (service "jira-pat"), never in this repo.
# Store it once per machine with:
#   security add-generic-password -s jira-pat -a $env.USER -w
# then resolve it on demand:
#   $env.JIRA_API_TOKEN = (security find-generic-password -s jira-pat -w | str trim)
$env.JIRA_AUTH_TYPE = "bearer"

$env.SSL_CERT_FILE = '/Users/athauvin/work/swissquote/certificates/ca-certificates.crt'

# Ruby via RVM (RVM's shell function doesn't work in nushell, so wire it up by hand)
$env.GEM_HOME = ($env.HOME | path join ".rvm/gems/ruby-3.4.5")
$env.GEM_PATH = ([
    ($env.HOME | path join ".rvm/gems/ruby-3.4.5")
    ($env.HOME | path join ".rvm/gems/ruby-3.4.5@global")
] | str join (char esep))


# PATH
use std/util "path add"
path add "~/.rvm/rubies/ruby-3.4.5/bin" "~/.rvm/gems/ruby-3.4.5/bin" "~/.rvm/gems/ruby-3.4.5@global/bin" "~/.rvm/bin" "~/dotfiles/scripts" "/opt/homebrew/bin" "/opt/homebrew/sbin" $"($env.ANDROID_HOME)/tools" $"($env.ANDROID_HOME)/tools/bin" $"($env.ANDROID_HOME)/platform-tools" $"($env.ANDROID_HOME)/emulator" "/opt" $"($env.M2_HOME)" "scripts" "/opt/android-studio/bin" "/usr/local/share/dotnet" "/usr/local/share" "~/.local/bin"

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
alias vpn-on = launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangp*
alias vpn-off = launchctl unload /Library/LaunchAgents/com.paloaltonetworks.gp.pangp*

# keep the builtin around
alias nu-open = open

# restore 'open' to the system Finder opener
alias open = ^open

# functions
# only used for SQ/timesheet
def tssup [hour comment = ""] { ts start $hour $"eb71b25fb54f1000fc322951351d0000 Maintenance/Bugfix/Support ($comment)" }
def tssbusiness [hour comment = ""] { ts start $hour $"37d365e8f24710013b4a632bd2f90001 Development ($comment)" }
def tsscommunity [hour comment = ""] { ts start $hour $"3515c2a1ff2110015b2c1c322a140000 community ($comment)" }
def tsstraining [hour comment = ""] { ts start $hour $"6320c5d3af8a1000f144e04fa7570001 ($comment)" }
def tssWultra [hour comment = ""] { ts start $hour $"2ea69c2f72a61000a23497c639fb0001 ($comment)" }

# open VS code for given file
def code [file] {
^open -a "Visual Studio Code" $file
}

# keybinding
stty intr '^E'

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
