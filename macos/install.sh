# install what is needed
echo "Installing what is needed via homebrew"

brew install raycast
brew install --cask nikitabobko/tap/aerospace
brew install starship
brew install nushell
brew install sketchybar
brew tap FelixKratz/formulae
brew install font-hack-nerd-font
brew install kitty
brew install luarocks

# Needed for sketchybar X aerospace
echo "Installing what is needed via luarocks"

luarocks install lua-cjson
luarocks install luaposix

# create and backup all config
echo "backing up config"

mkdir ~/.config/backup
mkdir ~/.config/backup/kitty
mkdir ~/.config/backup/aerospace
mkdir ~/.config/backup/nushell
mv ~/.config/kitty/kitty.conf ~/.config/backup/kitty/
mv ~/.config/aerospace/aerospace.toml ~/.config/backup/aerospace/
mv ~/.config/sketchybar ~/.config/backup/sketchybar
mv `~/Library/Application Support/nushell/config.nu` ~/.config/backup/nushell/

# create dirs
echo "creating dirs for aerospace and kitty"

mkdir ~/.config/aerospace
mkdir ~/.config/kitty

# symlink all config files
echo "creating symlink"

ln -s ~/dotfiles/macos/config/nushell/config.nu `~/Library/Application Support/nushell/config.nu`
ln -s ~/dotfiles/macos/config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/macos/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/dotfiles/macos/config/sketchybar/ ~/.config/sketchybar
ln -s ~/dotfiles/common/config/starship/starship.toml ~/.config/starship.toml

# launch all
echo "Starting Sketchybar"

brew services stop sketchybar
brew services start sketchybar

# make nushell as default shell
echo "setting nushell as default shell"

sudo bash -c 'echo "/opt/homebrew/bin/nu" >> /etc/shells'
chsh -s /opt/homebrew/bin/nu

echo "You can now launch aerospace!"
echo "Some changes will need a reboot such as default shell"