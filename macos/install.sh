# install what is needed
echo "Installing what is needed via homebrew"

echo "Installing borders"
brew tap FelixKratz/formulae
brew install borders

echo "Installing raycast"
brew install raycast

echo "Installing aerospace"
brew install --cask nikitabobko/tap/aerospace

echo "Installing starship"
brew install starship

echo "Installing nushell"
brew install nushell

echo "Installing sketchybar"
brew install sketchybar

echo "Installing nerd font"
brew install font-hack-nerd-font

echo "Installing kitty"
brew install kitty

echo "Installing luarocks"
brew install luarocks

echo "Installing node and pnpm"
brew install node
brew pnpm

# Installing fonts
echo "Installing fonts"
brew install --cask font-sf-pro
brew install --cask font-sf-mono
brew install --cask sf-symbols
brew install --cask font-hack-nerd-font
brew install --cask font-awesome
git clone git@github.com:kvndrsslr/sketchybar-app-font.git
cd sketchybar-app-font
pnpm install
pnpm run build:install

# Needed for sketchybar X aerospace
echo "Installing lua-cjson and luaposix needed by luarocks for sketchybar X aerospace"

luarocks install lua-cjson
luarocks install luaposix

# create and backup all config
echo "backing up config"

mkdir ~/.config/backup
mkdir ~/.config/backup/kitty
mkdir ~/.config/backup/aerospace
mkdir ~/.config/backup/nushell
mkdir ~/.config/backup/borders
mv ~/.config/kitty/kitty.conf ~/.config/backup/kitty/
mv ~/.config/borders/bordersrc ~/.config/backup/borders/
mv ~/.config/aerospace/aerospace.toml ~/.config/backup/aerospace/
mv ~/.config/sketchybar ~/.config/backup/sketchybar
mv `~/Library/Application Support/nushell/config.nu` ~/.config/backup/nushell/

# create dirs
echo "creating dirs for aerospace, kitty and borders"

mkdir ~/.config/aerospace
mkdir ~/.config/kitty
mkdir ~/.config/borders

# symlink all config files
echo "creating symlink"

ln -s ~/dotfiles/macos/config/nushell/config.nu `~/Library/Application Support/nushell/config.nu`
ln -s ~/dotfiles/macos/config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/macos/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/dotfiles/macos/config/borders/bordersrc ~/.config/borders/bordersrc
ln -s ~/dotfiles/macos/config/sketchybar/ ~/.config/sketchybar
ln -s ~/dotfiles/common/config/starship/starship.toml ~/.config/starship.toml

# launch all
echo "Starting borders via service"
brew services start borders

# make nushell as default shell
echo "setting nushell as default shell"

sudo bash -c 'echo "/opt/homebrew/bin/nu" >> /etc/shells'
chsh -s /opt/homebrew/bin/nu

echo "You can now launch aerospace!"
echo "Some changes will need a reboot such as default shell"