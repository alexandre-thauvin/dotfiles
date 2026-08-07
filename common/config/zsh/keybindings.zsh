#!/usr/bin/env zsh
# Key bindings. Sourced after plugins.zsh so these win over anything fzf or
# zsh-autosuggestions bind.
#
# The macOS-native layout, paired with macos/config/kitty/kitty.conf:
#   cmd+c / cmd+v      copy / paste          (handled by kitty, never reaches zsh)
#   ctrl+c             cancel                (passed through to the tty -> SIGINT)
#   alt+left/right     previous / next word
#   cmd+left/right     start / end of line
#   alt+bksp           delete previous word
#   cmd+bksp           delete the whole line
# kitty translates cmd/alt into the control sequences bound below, so these
# bindings also work unchanged over ssh and in any other terminal.

bindkey -e   # emacs mode -- makes ^A/^E/^W/^U/ESC-b/ESC-f behave as expected

# Word boundaries. zsh's default WORDCHARS contains '/' and '=', which makes
# alt+left swallow '~/work/swissquote' whole; dropping them stops at each path
# segment instead.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# ------------------------------------------------------- line start / end (cmd)
bindkey '^A' beginning-of-line          # kitty: cmd+left  -> \x01
bindkey '^E' end-of-line                # kitty: cmd+right -> \x05
bindkey '^[[H'  beginning-of-line       # Home
bindkey '^[[F'  end-of-line             # End
bindkey '^[OH'  beginning-of-line       # Home, application cursor mode
bindkey '^[OF'  end-of-line             # End, application cursor mode

# -------------------------------------------------------- word movement (alt)
bindkey '^[b' backward-word             # kitty: alt+left  -> \x1b\x62
bindkey '^[f' forward-word              # kitty: alt+right -> \x1b\x66
# ctrl+left / ctrl+right no longer send \x01 / \x05, so bind kitty's default CSI
# sequences for them -- otherwise they would insert escape garbage.
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
# Same for the alt+arrow CSI form, in terminals that send it instead of ESC-b/f.
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# ------------------------------------------------------------------- deletion
# Backwards, with backspace.
bindkey '^W' backward-kill-word         # kitty: alt+bksp  -> \x17
bindkey '^U' kill-whole-line            # kitty: cmd+bksp  -> \x15
bindkey '^?' backward-delete-char       # Backspace
bindkey '^H' backward-delete-char       # Backspace over ssh / linux consoles

# Forwards, with delete (fn+backspace on a laptop keyboard).
bindkey '^[[3~' delete-char             # Delete: one character
bindkey '^[d'   kill-word               # kitty: alt+delete -> \x1b\x64
bindkey '^K'    kill-line               # kitty: cmd+delete -> \x0b
bindkey '^[[3;3~' kill-word             # alt+Delete CSI form, other terminals
bindkey '^[[3;9~' kill-line             # cmd+Delete CSI form, other terminals

# --------------------------------------------------------- history (fish-like)
# Up/down search history for entries starting with what is already typed, which
# is the fish behaviour people miss most. Plain up/down when the line is empty.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search    # application cursor mode
bindkey '^[OB' down-line-or-beginning-search

# ------------------------------------------------------------------ completion
bindkey '^[[Z' reverse-menu-complete    # shift+tab walks the menu backwards

# Accept the greyed-out autosuggestion.
if (( $+functions[_zsh_autosuggest_widget_accept] )); then
  bindkey '^[[C' forward-char          # right arrow accepts, char by char
  bindkey '^ '   autosuggest-accept    # ctrl+space accepts the whole thing
fi

# Edit the current command line in $EDITOR with ctrl-x ctrl-e.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
