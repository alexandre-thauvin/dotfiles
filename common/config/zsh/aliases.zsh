#!/usr/bin/env zsh
# Portable aliases. Anything macOS-only (vpn, timesheet, code) lives in
# macos/config/zsh/zshrc instead.

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ne='emacs'
alias dlt="$HOME/dotfiles/scripts/mr_clean"

# ------------------------------------------------------------------ eza  (ls)
if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons'
  alias l='eza -1 --group-directories-first --icons'
  alias ll='eza -l --group-directories-first --icons --git --time-style=long-iso'
  alias la='eza -la --group-directories-first --icons --git --time-style=long-iso'
  alias lt='eza --tree --level=2 --group-directories-first --icons'
  alias tree='eza --tree --group-directories-first --icons'
else
  alias ls='ls -G'
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# ------------------------------------------------------------------ bat  (cat)
if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  alias catp='bat'                 # with pager, when you do want to scroll
  export BAT_THEME='Monokai Extended'
  # Colourised man pages.
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
fi

# --------------------------------------------------------------------- git
alias gs='git status --short --branch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git pull --rebase'

# ------------------------------------------------------------------- misc
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d='dirs -v'                  # numbered dir stack (AUTO_PUSHD feeds it)
alias reload='exec zsh'            # pick up config changes
alias path='print -l $path'        # one PATH entry per line
