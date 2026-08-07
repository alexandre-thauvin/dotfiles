#!/usr/bin/env zsh
# History: large, shared between concurrent shells, de-duplicated.

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000        # kept in memory
SAVEHIST=50000        # kept on disk

setopt EXTENDED_HISTORY       # record timestamp and duration
setopt INC_APPEND_HISTORY     # write as commands are run, not only at exit
setopt SHARE_HISTORY          # new shells see commands from live shells
setopt HIST_IGNORE_ALL_DUPS   # a repeated command keeps only its newest entry
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS     # tidy up whitespace before storing
setopt HIST_VERIFY            # expand !! etc. onto the line instead of running it
setopt HIST_FIND_NO_DUPS      # don't offer the same match twice when searching
