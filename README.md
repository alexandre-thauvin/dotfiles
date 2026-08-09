# dotfiles

Here is my config for MacOS and Archlinux. Some are common, some are specific.

## MacOS

https://github.com/user-attachments/assets/ebc9aa01-1a14-4ff1-9889-726ef9c63a0c

[Aerospace](https://github.com/nikitabobko/AeroSpace)
The best window manager for macOS by far

[SketchyBar](https://github.com/FelixKratz/SketchyBar?tab=readme-ov-file)
A custom status bar

[SbarLua](https://github.com/FelixKratz/SbarLua)
Lua API for SketchyBar

[JankyBorders](https://github.com/FelixKratz/JankyBorders)
Make borders of focused window

[Kitty](https://sw.kovidgoyal.net/kitty/)
Terminal

[zsh](https://www.zsh.org/)
Shell. Ships with macOS. `macos/config/zsh/zshrc` is symlinked to `~/.zshrc` and
sources the portable modules in `common/config/zsh/`. Previously nushell, dropped
because its non-POSIX syntax broke most commands copied from docs or colleagues,
and bash-only integrations such as RVM had to be reimplemented by hand.

[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
Fish-style greyed-out inline suggestion, accepted with `->`

[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
Colours the command line as you type

[fzf](https://github.com/junegunn/fzf) + [fzf-tab](https://github.com/Aloxaf/fzf-tab)
Fuzzy finder, and Tab completion driven by it with directory/file previews

[zoxide](https://github.com/ajeetdsouza/zoxide)
`z <partial-name>` jumps to the matching directory you use most

[eza](https://github.com/eza-community/eza) and [bat](https://github.com/sharkdp/bat)
Modern `ls` and `cat`

[Starship](https://starship.rs/)
Nice prompt for many shells — `gruvbox-rainbow` preset, shared with the Arch box
through `common/config/starship/starship.toml`

### Keys

Editing keys follow the macOS convention rather than the Linux one. kitty
translates them into standard emacs-mode control sequences, so they behave the
same in zsh, bash, psql, python and over ssh.

| Key | Does |
| --- | --- |
| `cmd+c` / `cmd+v` | copy / paste |
| `ctrl+c` | cancel (SIGINT) |
| `alt+left` / `alt+right` | previous / next word |
| `cmd+left` / `cmd+right` | start / end of line |
| `alt+bksp` / `cmd+bksp` | delete previous word / whole line |
| `up` / `down` | history filtered by what is already typed |
| `ctrl+r` / `ctrl+t` | fuzzy history / file search |
| `ctrl+x ctrl+e` | edit the current line in `$EDITOR` |

### Secrets

No secret is committed. Tokens live in the macOS Keychain and are read on first
use by the `secret` helper in `common/config/zsh/secrets.zsh`. Per machine:

```sh
security add-generic-password -s jira-pat -a "$USER" -w   # prompts for the value
```

### Installation

There is a `install.sh` under `dotfiles/macos`. It will:
- install all requirements listed above
- backup your config files if existing
- create symlink to config files (feel free to remove the symlink and do a copy and change the config files as you wish)
- start the apps
- set zsh as the default shell, and remind you to add the Jira token to the Keychain


## Archlinux

[i3-wm](https://i3wm.org/) Window manager

![image](https://github.com/user-attachments/assets/9ad1dd5b-405b-4fdf-944f-b68078d6d566)

[i3-status & bar](https://i3wm.org/docs/i3status.html) Status bar for i3

[keyd](https://github.com/rvaiya/keyd) key remapping, lightweight, operate at very low level

![image](https://github.com/user-attachments/assets/574e7dcd-9589-4482-a791-d4e5f3b30007)


[i3-workspace-names-daemon](https://github.com/alexandre-thauvin/i3-workspace-names-daemon) Custom dynamic workspaces reflected in status bar

![image](https://github.com/user-attachments/assets/a375cda4-cb2b-4f89-b30e-c0d614d7860c)


## Scripts

There is some diverses scripts such as:
- Toggle bluetooth for auto-connect
- Show running activities on any android devices connected through ADB
- A script to take screenshot
- Restart pulseaudio
- i3 special lock via [i3lock](https://i3wm.org/i3lock/)
- Superfind, powerful find
- Superkill, powerful kill
- setRandomWallpapers


