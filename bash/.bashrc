#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/heidam/bin:/usr/heimdal/sbin:/home/tauvi_a/utile"
export ANDROID_HOME=/opt/android-sdk
export EDITOR=/usr/bin/emacs

alias ls='ls --color=auto'
alias grep='grep --color'
alias refresh="source ~/.bashrc"
alias sublime='subl'
alias mk='make'
alias sub='/opt/sublime-text/sublime_text'
alias mr='make re'
alias mf='make fclean'
alias mc='make clean'
alias ne='emacs'
alias ..='cd ..'
alias dlt='/home/thauvi_a/utile/mr_clean'
alias g1='/home/thauvi_a/utile/push.sh'
alias g2='/home/thauvi_a/utile/create.sh'
alias g3='/home/thauvi_a/utile/clone.sh'
alias lock='i3lock -t -i /home/thauvi_a/Pictures/wallpaper/`ls /home/thauvi_a/Pictures/wallpaper | head -$((RANDOM%$(ls /home/thauvi_a/Pictures/wallpaper | wc -w)+1)) | tail -1`'

alias l='ls -l'
alias unmount='/home/thauvi_a/utile/unmount.sh'
alias off='poweroff'
alias update="/home/thauvi_a/utile/update.sh"
alias mount_dde="/home/thauvi_a/utile/mount.sh"
alias network="systemctl restart NetworkManager"

export USER="thauvi_a"
export USER_NICKNAME="Alexandre Thauvin"

PS1='[\u@\h \W]\$ '
