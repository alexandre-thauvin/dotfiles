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
  # Two spawns per shell start are being cached away here: `starship init zsh`
  # itself (~14ms), and the `starship prompt --continuation` that its output runs
  # eagerly to fill PROMPT2 (~16ms). Requoting that one assignment leaves it for
  # zsh to expand on first use instead -- promptsubst is on by then (the init
  # sets it a few lines earlier, for PROMPT and RPROMPT, which are command
  # substitutions for exactly the same reason), and a continuation prompt is
  # usually never drawn at all. If starship ever changes the line, the sed simply
  # does not match and we are back to the eager spawn.
  _starship_init_script() {
    starship init zsh | sed "s/^PROMPT2=\"\(\$(.*)\)\"\$/PROMPT2='\1'/"
  }
  zsh_eval_cache starship _starship_init_script
  unfunction _starship_init_script
fi
