#!/usr/bin/env zsh
# Completion system. Must be sourced before plugins.zsh -- fzf-tab wraps the
# completion system that compinit sets up here.

# ---------------------------------------------------------------------- options
# Set first: the compinit cache check below uses an EXTENDED_GLOB qualifier.

setopt EXTENDED_GLOB        # ^, #, ~ and (#q...) glob qualifiers
setopt AUTO_CD              # `swissquote` alone cds into it
setopt AUTO_PUSHD           # every cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt COMPLETE_IN_WORD     # complete from the cursor, not only at end of word
setopt ALWAYS_TO_END        # move the cursor to the end after completing
setopt NO_CASE_GLOB         # *.PNG matches *.png
setopt INTERACTIVE_COMMENTS # allow `# comment` on an interactive line
setopt NO_FLOW_CONTROL      # free up ctrl-s / ctrl-q
unsetopt BEEP

# Used by the completion list-colors below and by `ls` (BSD ls ignores it, but
# eza and the completion menu both read it).
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export CLICOLOR=1

# ------------------------------------------------------------------- completion

# Homebrew's completions, plus the extra ones from the zsh-completions formula.
if (( $+commands[brew] )); then
  fpath=(
    /opt/homebrew/share/zsh-completions
    /opt/homebrew/share/zsh/site-functions
    $fpath
  )
fi

autoload -Uz compinit

# compinit's security audit walks every fpath directory, which is slow. Run the
# full check only when the dump is more than 24h old; otherwise trust the cache.
#
# -i skips any group/world-writable fpath directory instead of stopping to ask.
# Without it, one bad directory turns every new shell into a blocking y/n prompt
# and aborts completion entirely. Homebrew occasionally ships a formula that
# leaves /opt/homebrew/share at 0775, which is exactly that situation -- if
# completions ever go missing, run `compaudit` and chmod g-w whatever it lists.
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n ${_zcompdump}(#qN.mh+24) || ! -s $_zcompdump ]]; then
  compinit -i -d "$_zcompdump"
  # Recompile in the background so later shells load bytecode instead of parsing.
  { zcompile -R -- "$_zcompdump" } &!
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# --------------------------------------------------------------------- zstyles

zstyle ':completion:*' menu select                      # arrow-key selectable menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colour matches like ls
zstyle ':completion:*' group-name ''                    # group by category...
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'  # ...with headers
zstyle ':completion:*' verbose true
zstyle ':completion:*' squeeze-slashes true

# Case-insensitive, then partial-word, then substring matching.
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Cache slow completions (brew, gradle, ...) under the standard cache dir.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Don't offer the current directory back when completing `cd ..`; make kill's
# process list selectable.
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
