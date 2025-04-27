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

[Nushell](https://www.nushell.sh/)
Structued shell

[Starship](https://starship.rs/)
Nice prompt for many shells

### Installation

There is a `install.sh` under `dotfiles/macos`. It will:
- install all requirements listed above
- backup your config files if existing
- create symlink to config files (feel free to remove the symlink and do a copy and change the config files as you wish)
- start the apps


## Archlinux

[i3-wm](https://i3wm.org/)

![image](https://github.com/user-attachments/assets/9ad1dd5b-405b-4fdf-944f-b68078d6d566)

[i3-status & bar](https://i3wm.org/docs/i3status.html)

![image](https://github.com/user-attachments/assets/574e7dcd-9589-4482-a791-d4e5f3b30007)


[Custom dynamic workspaces reflected in status bar](https://github.com/alexandre-thauvin/i3-workspace-names-daemon)

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


