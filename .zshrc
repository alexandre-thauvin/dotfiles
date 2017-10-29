# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/thauvi_a/.oh-my-zsh
ZSH_THEME="kafeitu"

source ~/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

antigen bundle zsh-users/zsh-completions

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
 export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/heidam/bin:/usr/heimdal/sbin:/home/thauvi_a/utile:/home/thauvi_a/idea-IU-172.4343.14/bin"
export ANDROID_HOME="/opt/android-sdk/"
export EDITOR="/usr/bin/emacs"

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
