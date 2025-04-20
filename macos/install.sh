# install what is needed
brew install raycast
brew install --cask nikitabobko/tap/aerospace
brew install starship
brew install nushell
brew install sketchybar
brew tap FelixKratz/formulae
brew install sketchybar
brew install font-hack-nerd-font

# create and backup all config
mkdir ~/.config/backup
mkdir ~/.config/backup/kitty
mkdir ~/.config/backup/aerospace
mkdir ~/.config/backup/nushell
mv ~/.config/kitty/kitty.conf ~/.config/backup/kitty/
mv ~/.config/aerospace/aerospace.toml ~/.config/backup/aerospace/
mv ~/.config/sketchybar ~/.config/backup/sketchybar
mv `~/Library/Application Support/nushell/config.nu` ~/.config/backup/nushell/

# symlink all config files
ln -s ~/dotfiles/macos/config/nushell/config.nu `~/Library/Application Support/nushell/config.nu`
ln -s ~/dotfiles/macos/config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/macos/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/dotfiles/macos/config/sketchybar/ ~/.config/sketchybar
ln -s ~/dotfiles/common/config/starship/starship.toml ~/.config/starship/starship.toml

# launch all
brew services start sketchybar

# make nushell as default shell
sudo chsh -s /opt/homebrew/bin/nu

printf("\nAdd /opt/homebrew/bin/nu to /etc/shells")
printf("\nYou can now launch aerospace")