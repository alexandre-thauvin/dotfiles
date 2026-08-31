#!/usr/bin/env zsh
# Suggestions, highlighting, fuzzy completion and directory jumping.
#
# LOAD ORDER IS LOAD-BEARING -- getting it wrong fails silently:
#   1. fzf key-bindings + completion
#   2. fzf-tab           -- must come after compinit (completion.zsh) or it has
#                           no completion system to wrap
#   3. zsh-autosuggestions
#   4. zoxide
#   5. zsh-syntax-highlighting -- MUST BE LAST; it wraps every ZLE widget that
#                           exists at the moment it is sourced

_brew_share=/opt/homebrew/share

# ------------------------------------------------------------------------- fzf
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border --info=inline'
  if (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  # ctrl-t files, ctrl-r history, alt-c cd
  [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] \
    && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] \
    && source /opt/homebrew/opt/fzf/shell/completion.zsh 2>/dev/null
fi

# ---------------------------------------------------------------------- fzf-tab
# Turns Tab into an fzf picker with previews. Not in Homebrew; install.sh clones
# it to ~/.local/share/zsh/fzf-tab.
if [[ -f "$HOME/.local/share/zsh/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/.local/share/zsh/fzf-tab/fzf-tab.plugin.zsh"

  # fzf-tab needs to drive the menu itself, so zsh's own menu must be off.
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:*' switch-group ',' '.'
  zstyle ':fzf-tab:complete:*:*' fzf-flags --height=60%

  # Preview directory contents when completing cd/ls/etc.
  # --icons=always, not a bare --icons: the flag's value is optional, so a
  # trailing bare --icons would consume $realpath and the preview pane would come
  # up empty -- silently, because the error goes to the /dev/null below.
  # 'always' rather than 'auto' since fzf's preview is a pipe, not a tty.
  if (( $+commands[eza] )); then
    zstyle ':fzf-tab:complete:(cd|ls|eza|rm|mv|cp):*' fzf-preview \
      'eza -1 --color=always --icons=always $realpath 2>/dev/null'
  fi
  # Preview file contents elsewhere.
  if (( $+commands[bat] )); then
    zstyle ':fzf-tab:complete:(bat|cat|less|vim|nvim|code):*' fzf-preview \
      'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null'
  fi
  # Show what a variable actually holds.
  zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'
fi

# ------------------------------------------------------------- autosuggestions
# Fish-style greyed-out inline suggestion; -> or End accepts it.
if [[ -f "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  # Sonokai grey, matching macos/config/sketchybar/colors.lua
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f8490'
  # Fall back to completion when history has nothing to offer.
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  # Only needed because the fetch is synchronous: every keystroke runs a history
  # glob, so pasting a multi-KB blob would stutter. Keep it well clear of any real
  # command line -- past the cap the plugin skips the *fetch*, and because it can
  # still slice a suggestion it already holds, that shows up as suggestions dying
  # only when you delete a word from a long line while typing forward keeps
  # working. At 20 the cliff sat mid-`bundle exec fastlane`.
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=500
  source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# ----------------------------------------------------------------------- zoxide
# `z swissquote` jumps to the most-used matching directory; `zi` picks with fzf.
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# ------------------------------------------------------------ syntax highlight
# LAST. Wraps every widget defined above, so anything sourced after it loses
# highlighting.
if [[ -f "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
  source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset _brew_share
