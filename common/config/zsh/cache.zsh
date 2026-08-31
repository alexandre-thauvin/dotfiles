#!/usr/bin/env zsh
# Cache for the init snippets tools print for us (`starship init zsh`,
# `zoxide init zsh`, ...). Each of those costs a process spawn plus a parse of a
# few hundred lines of zsh on *every* shell start -- together ~20ms here.
#
# Must be sourced before anything that calls zsh_eval_cache.

_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $_zsh_cache_dir ]] || mkdir -p "$_zsh_cache_dir"

# zsh_eval_cache <tool> <command> [args...]
#   Replaces `eval "$(command args)"`: runs it once, stores the output and sources
#   that instead from then on. zcompile turns the cache into bytecode, so later
#   shells skip parsing it too.
#
#   <tool> names the cache file and is the binary the cache is invalidated
#   against, so `brew upgrade starship` is picked up by the next shell. <command>
#   is what actually prints the snippet and may be a shell function -- prompt.zsh
#   uses one to post-process starship's init.
#
#   Changing the *arguments* is not detected -- delete "$_zsh_cache_dir" after
#   doing that. Callers must check the tool exists first (`(( $+commands[x] ))`).
zsh_eval_cache() {
  local tool=$1 cache="$_zsh_cache_dir/$1.zsh"
  shift
  if [[ ! -s $cache || $commands[$tool] -nt $cache ]]; then
    # Via a temp file: a command that dies half way through would otherwise
    # leave a truncated cache behind, and every later shell would source it.
    "$@" >| "$cache.new" || {
      print -u2 "zsh_eval_cache: ${(j: :)@} failed"
      rm -f "$cache.new"
      return 1
    }
    mv -f "$cache.new" "$cache"
    # zsh only uses a .zwc that is newer than its source, so this has to follow
    # the mv, not precede it.
    zcompile -R -- "$cache"
  fi
  source "$cache"
}
