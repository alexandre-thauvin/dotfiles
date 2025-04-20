# install what is needed
brew install raycast
brew install --cask nikitabobko/tap/aerospace
brew install starship
brew install nushell
brew install sketchybar
brew tap FelixKratz/formulae
brew install sketchybar
brew install font-hack-nerd-font
brew install kitty
brew install luarocks

# Needed for sketchybar X aerospace
luarocks install lua-cjson
luarocks install luaposix

# create and backup all config
mkdir ~/.config/backup
mkdir ~/.config/backup/kitty
mkdir ~/.config/backup/aerospace
mkdir ~/.config/backup/nushell
mv ~/.config/kitty/kitty.conf ~/.config/backup/kitty/
mv ~/.config/aerospace/aerospace.toml ~/.config/backup/aerospace/
mv ~/.config/sketchybar ~/.config/backup/sketchybar
mv `~/Library/Application Support/nushell/config.nu` ~/.config/backup/nushell/

# create dirs
mkdir ~/.config/aerospace
mkdir ~/.config/starship
mkdir ~/.config/kitty

# symlink all config files
ln -s ~/dotfiles/macos/config/nushell/config.nu `~/Library/Application Support/nushell/config.nu`
ln -s ~/dotfiles/macos/config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/macos/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/dotfiles/macos/config/sketchybar/ ~/.config/sketchybar
ln -s ~/dotfiles/common/config/starship/starship.toml ~/.config/starship/starship.toml

# launch all
brew services start sketchybar

# make nushell as default shell
sudo bash -c 'echo "/opt/homebrew/bin/nu" >> /etc/shells'
chsh -s /opt/homebrew/bin/nu

printf("You can now launch aerospace!")