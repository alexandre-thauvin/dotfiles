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
#   shift+arrow        select by character
#   alt+shift+arrow    select by word
#   cmd+shift+arrow    select to start / end of line
#   cmd+x              cut the selection
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

# ----------------------------------------------------------- selection (shift)
# A terminal has no text selection of its own, but zle does: MARK and CURSOR
# delimit a region that zsh highlights by itself as soon as REGION_ACTIVE is
# non-zero. Each widget below anchors MARK on the first shifted keypress and
# then leaves it alone, so repeated presses grow one selection the way they do
# in a GUI editor.
#
#   shift+left/right       extend by one character
#   alt+shift+left/right   extend by one word
#   cmd+shift+left/right   extend to start / end of line
#   cmd+x                  cut the selection, or the whole line if there is none
#   cmd+shift+c            copy the selection -- cmd+c belongs to kitty, where
#                          it copies the *mouse* selection instead.

_shift-select-extend() {
  (( REGION_ACTIVE )) || { MARK=$CURSOR; REGION_ACTIVE=1 }
  zle "$1"
}
shift-select-bol()      { _shift-select-extend beginning-of-line }
shift-select-eol()      { _shift-select-extend end-of-line }
shift-select-bwd-word() { _shift-select-extend backward-word }
shift-select-fwd-word() { _shift-select-extend forward-word }
shift-select-bwd-char() { _shift-select-extend backward-char }
shift-select-fwd-char() { _shift-select-extend forward-char }

# Any other widget -- a plain arrow, a typed character, a completion -- drops
# the selection, which is what makes the highlight behave like a real one.
# line-pre-redraw is the only hook that sees *every* widget, so the test lives
# there instead of in a wrapper around each individual movement key.
_shift-select-drop() { [[ $LASTWIDGET == shift-select-* ]] || (( REGION_ACTIVE = 0 )) }

# Cut and copy. zle leaves the text in $CUTBUFFER; the clipboard command hands
# it to the desktop so cmd+v pastes it into any other app. Resolved once here
# because this file is shared with Linux. This is the *local* clipboard, so
# unlike every other binding in this file cmd+x over ssh fills the clipboard of
# the remote machine rather than the one in front of you.
if   (( $+commands[pbcopy]  )); then _shift_select_clip=(pbcopy)
elif (( $+commands[wl-copy] )); then _shift_select_clip=(wl-copy)
elif (( $+commands[xclip]   )); then _shift_select_clip=(xclip -selection clipboard)
else                                 _shift_select_clip=()
fi

_shift-select-to-clipboard() {
  (( $#_shift_select_clip )) && print -rn -- "$CUTBUFFER" | "$_shift_select_clip[@]"
}
shift-select-cut() {
  if (( REGION_ACTIVE )); then zle kill-region; else zle kill-whole-line; fi
  (( REGION_ACTIVE = 0 ))
  _shift-select-to-clipboard
}
shift-select-copy() {
  (( REGION_ACTIVE )) || return
  zle copy-region-as-kill
  (( REGION_ACTIVE = 0 ))
  _shift-select-to-clipboard
}

for _w in shift-select-{bol,eol,bwd-word,fwd-word,bwd-char,fwd-char,cut,copy} \
          _shift-select-drop; do
  zle -N $_w
done
unset _w

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _shift-select-drop

bindkey '^[[1;2D'   shift-select-bwd-char   # shift+left
bindkey '^[[1;2C'   shift-select-fwd-char   # shift+right
bindkey '^[[1;4D'   shift-select-bwd-word   # kitty: alt+shift+left
bindkey '^[[1;4C'   shift-select-fwd-word   # kitty: alt+shift+right
bindkey '^[[1;10D'  shift-select-bol        # kitty: cmd+shift+left
bindkey '^[[1;10C'  shift-select-eol        # kitty: cmd+shift+right
bindkey '^[[120;9u' shift-select-cut        # kitty: cmd+x
bindkey '^[[99;10u' shift-select-copy       # kitty: cmd+shift+c

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
