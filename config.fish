for f in ~/.config/fish/functions/*.fish
  source $f
 end

set --export ANDROID_HOME /opt/android-studio;
set -gx PATH $ANDROID_HOME/tools $PATH;
set -gx PATH $ANDROID_HOME/tools/bin $PATH;
set -gx PATH $ANDROID_HOME/platform-tools $PATH;
set -gx PATH $ANDROID_HOME/emulator $PATH;
set --export SNAP /snap 

set --export JAVA_HOME /opt/android-studio/jre;
set -gx PATH "/home/toto/.local/bin:/var/lib/snapd/snap/bin:/opt/android-studio/bin:/bin:/sbin:/usr/bin:/usr/local/share/dotnet:/usr/local/bin:/usr/sbin:/usr/local/share:/flutter/bin:/home/toto/dotfiles/scripts:$JAVA_HOME" $PATH;


alias grep='grep --color'
alias shutdown='systemctl poweroff -i'
alias ne='emacs'
alias ls='ls -l --color=auto'
alias grep='grep --color'
alias refresh="source ~/.config/fish/config.fish"
alias dlt='mr_clean'

thefuck --alias | source
