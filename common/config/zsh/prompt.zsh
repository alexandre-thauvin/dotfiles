#!/usr/bin/env zsh
# Prompt: starship, themed by common/config/starship/starship.toml (symlinked to
# ~/.config/starship.toml). Kept shell-agnostic on purpose -- the same file drives
# the prompt on the Arch box.
#
# Note: starship's transient prompt (enable_transience) is implemented for fish,
# nushell and PowerShell only -- `starship init zsh` exposes no such function, so
# there is nothing to enable here. Powerlevel10k is the option if a transient
# prompt ever becomes worth a zsh-only prompt.

if (( $+commands[starship] )); then
  export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  eval "$(starship init zsh)"
fi
