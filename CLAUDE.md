# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for two machines: a macOS laptop (actively used) and an Arch Linux box.
There is no build, no test suite and no CI — the "product" is a set of config files that get
symlinked into `~/.config`. Correctness is verified by reloading the affected app.

The repo is expected to live at `~/dotfiles`. `macos/install.sh` hardcodes that path in every
`ln -s`, and `macos/config/zsh/zshrc` defaults `$DOTFILES` to it.

## Layout

```
common/config/<app>/     shared between macOS and Arch (zsh modules, starship)
macos/config/<app>/      macOS-only (zsh entry point, aerospace, sketchybar, kitty, borders)
archlinux/config/<app>/  Arch-only (i3, i3blocks, keyd, kitty, ulauncher, nushell)
scripts/                 standalone helper scripts; on $PATH via zshrc
macos/install.sh         the only installer (there is none for Arch)
```

Anything portable belongs in `common/`; anything that names a Homebrew path, `launchctl`,
`osascript`, `/usr/libexec/java_home` or the Keychain belongs under `macos/`.

## Applying changes

Only these paths are symlinked, so edits to them take effect without reinstalling:

| Repo file | Target |
| --- | --- |
| `macos/config/zsh/zshrc` | `~/.zshrc` |
| `macos/config/aerospace/aerospace.toml` | `~/.config/aerospace/aerospace.toml` |
| `macos/config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `macos/config/borders/bordersrc` | `~/.config/borders/bordersrc` |
| `macos/config/sketchybar/` (whole dir) | `~/.config/sketchybar` |
| `common/config/starship/starship.toml` | `~/.config/starship.toml` |

`common/config/zsh/*.zsh` is not symlinked — it is sourced directly out of the repo by `zshrc`.

```sh
exec zsh                          # reload shell config (aliased to `reload`)
sketchybar --reload               # reload the bar; also rebuilds nothing, see below
aerospace reload-config
brew services restart borders
scripts/restart_aerospace.sh      # kill + restart aerospace and sketchybar together
luac -p macos/config/sketchybar/**/*.lua   # syntax-check lua before reloading
```

kitty reloads its config with `ctrl+cmd+,` or on restart.

## zsh configuration

`macos/config/zsh/zshrc` is the entry point: it sets macOS-specific environment (JAVA_HOME via
`java_home`, `ANDROID_HOME`, `$path`, lazy RVM, Swissquote timesheet aliases/functions), then
sources the portable modules from `common/config/zsh/`.

**The source order at the bottom of `zshrc` is load-bearing and failures are silent:**
`history → aliases → secrets → completion → plugins → keybindings → prompt`.
`completion.zsh` must run `compinit` before `plugins.zsh` sources fzf-tab (fzf-tab wraps the
completion system), and `keybindings.zsh` must run after plugins so its `bindkey` calls win.

Inside `plugins.zsh` the order is also load-bearing: fzf → fzf-tab → zsh-autosuggestions →
zoxide → **zsh-syntax-highlighting last**, because it wraps every ZLE widget that exists when it
is sourced.

### Guard everything

The same config is shared across machines that do not all have Maven, RVM, the Android SDK or
the Swissquote CA bundle. Every optional thing is behind `(( $+commands[foo] ))`, `[[ -d ... ]]`
or `[[ -f ... ]]`, and `$path` is built by filtering candidates through `[[ -d ]]`. Follow this
when adding anything: an unconditional export of a missing path is worse than nothing
(`SSL_CERT_FILE` pointing at a missing file breaks *every* HTTPS request; a bad `JAVA_HOME`
aborts Gradle/Maven outright).

### eza flags

Always write `--icons=auto` (or `--icons=always` in fzf-tab previews), never a bare `--icons`.
Since eza 0.19 the flag takes an optional value, so a trailing bare `--icons` swallows the next
positional argument.

## Key bindings: kitty and zsh are one contract

`macos/config/kitty/kitty.conf` maps macOS-convention keys (`cmd+left`, `alt+bksp`, …) to the
standard emacs-mode control sequences, and `common/config/zsh/keybindings.zsh` binds those
sequences to ZLE widgets. **Changing one without the other breaks the key.** Both files carry the
same table in comments; keep them in sync, and keep the README's key table in sync too.

`ctrl+c` is deliberately unmapped in kitty so it reaches the tty as SIGINT.
`ctrl+alt+left/right` cycles kitty tabs and `ctrl+alt+up/down` cycles splits — plain `alt+arrow`
stays word movement.

## Secrets

Nothing secret is committed. `common/config/zsh/secrets.zsh` exposes `secret <service-name>`,
which reads the macOS Keychain (`security`) or libsecret (`secret-tool`). The `jira` wrapper
resolves `JIRA_API_TOKEN` lazily on first call so no shell startup pays for a Keychain read or
an unlock prompt. Add new secrets the same way — a lazy wrapper around `secret`, never an export
at startup and never a value in the repo.

## SketchyBar (macOS status bar)

Lua config driven by [SbarLua](https://github.com/FelixKratz/SbarLua), whose native module is
loaded from `~/.local/share/sketchybar_lua/` by `helpers/init.lua`.

Startup chain:

1. `sketchybarrc` → `require("helpers")` → `helpers/init.lua` sets `package.cpath` and runs
   `(cd helpers && make)`, so the C helpers are **rebuilt on every sketchybar start**.
2. `init.lua` constructs the AeroSpace client and blocks until its socket answers, then
   `require`s `bar` → `default` → `items` inside `sbar.begin_config()`/`end_config()` and enters
   `sbar.event_loop()`.

Pieces:

- `aerospace.lua` — hand-rolled client speaking AeroSpace's JSON protocol over the unix socket
  `/tmp/bobko.aerospace-$USER.sock`. Exposed to items as `sbar.aerospace`.
- `items/init.lua` — the registry; a new item must be `require`d there to appear.
- `items/widgets/*.lua` — right-side widgets. `cpu.lua` and the network widget `sbar.exec` their
  C event provider (`helpers/event_providers/{cpu_load,network_load}/bin/…`), which pushes custom
  events (`cpu_update`, …) on a timer.
- `helpers/menus/menus.c` — native macOS menu-bar reader used by `items/menus.lua`.
- `colors.lua` (Sonokai palette), `settings.lua`, `icons.lua` — shared styling. The palette is
  also mirrored in `plugins.zsh` (`ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f8490'` is
  `colors.grey`); keep them consistent.

Requires `luarocks install lua-cjson luaposix` — `aerospace.lua` needs both.

## AeroSpace ↔ SketchyBar coupling

`aerospace.toml` drives the bar: `after-startup-command` launches `sketchybar`, and
`exec-on-workspace-change` fires `sketchybar --trigger aerospace_workspace_change`, which
`items/spaces.lua` subscribes to. `gaps.outer.top = 60` is what leaves room for the bar — changing
the bar height in `bar.lua` means changing that gap too.

## scripts/

On `$PATH` via `zshrc`. Mixed provenance: several (`mr_clean`, `superfind`, `superkill`,
`show_running_activities.sh`, `restart_pulseaudio.sh`, `start_blt_autoconnect.sh`) have
`#!/usr/bin/env fish` shebangs and use fish `$argv` syntax, and some are Linux-only
(`lock.sh` uses i3lock, `setRandomWallpapers.sh` uses feh, with hardcoded `/home/toto` paths).
Don't assume a script is portable or POSIX — read the shebang before editing.

## Arch Linux side

Config only, no installer; apply by copying or symlinking by hand. `archlinux/config/nushell/`
is a leftover — nushell was dropped on macOS in favour of zsh (see the README for the reasoning)
but the Arch config was not removed.

## Conventions

- Comments explain *why*, especially when a line exists to work around a specific failure —
  most non-obvious lines here carry that history, and it is worth preserving when refactoring.
- Commit messages are short imperative sentences ("Pin kitty's shell to /bin/zsh"). Work lands
  on `master`, occasionally via a PR from a `feat/…` branch.
- The README documents installed tools, the key table and the secrets step; update it when
  adding a tool to `install.sh` or changing a key binding.
