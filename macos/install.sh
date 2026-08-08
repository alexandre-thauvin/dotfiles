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

echo "Installing zsh completion, suggestions and highlighting"
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-completions

echo "Installing shell tools (fuzzy finder, dir jumping, better ls/cat, grep)"
# ripgrep is what plugins.zsh points FZF_DEFAULT_COMMAND at, so ctrl-t/ctrl-r
# search hidden files and honour .gitignore instead of falling back to find.
brew install fzf zoxide eza bat ripgrep

echo "Installing fzf-tab (not in homebrew)"
mkdir -p ~/.local/share/zsh
git clone --depth 1 https://github.com/Aloxaf/fzf-tab.git ~/.local/share/zsh/fzf-tab

echo "Installing sketchybar"
brew install sketchybar

echo "Installing nerd font"
# A cask, not a formula -- `brew install font-hack-nerd-font` errors out.
# (Also installed in the fonts block below; harmless, brew is idempotent.)
brew install --cask font-hack-nerd-font

echo "Installing kitty"
brew install kitty

echo "Installing luarocks"
brew install luarocks

echo "Installing node and pnpm"
brew install node
brew install pnpm

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

mkdir -p ~/.config/backup/kitty
mkdir -p ~/.config/backup/aerospace
mkdir -p ~/.config/backup/zsh
mkdir -p ~/.config/backup/borders
mv ~/.config/kitty/kitty.conf ~/.config/backup/kitty/
mv ~/.config/borders/bordersrc ~/.config/backup/borders/
mv ~/.config/aerospace/aerospace.toml ~/.config/backup/aerospace/
mv ~/.config/sketchybar ~/.config/backup/sketchybar
mv ~/.zshrc ~/.config/backup/zsh/

# create dirs
echo "creating dirs for aerospace, kitty and borders"

mkdir -p ~/.config/aerospace
mkdir -p ~/.config/kitty
mkdir -p ~/.config/borders

# symlink all config files
echo "creating symlink"

ln -s ~/dotfiles/macos/config/zsh/zshrc ~/.zshrc
ln -s ~/dotfiles/macos/config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/macos/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/dotfiles/macos/config/borders/bordersrc ~/.config/borders/bordersrc
ln -s ~/dotfiles/macos/config/sketchybar/ ~/.config/sketchybar
ln -s ~/dotfiles/common/config/starship/starship.toml ~/.config/starship.toml

# zsh completions
# Homebrew leaves share/ group-writable, which compinit treats as insecure. Since
# completion.zsh runs `compinit -i` (skip rather than block on a y/n prompt), the
# result is not a warning but Homebrew's completions silently never loading. Drop
# the group write bit so compaudit is clean and brew/gh/git completions work.
echo "tightening permissions on brew's completion dirs"
chmod g-w /opt/homebrew/share

# launch all
echo "Starting borders via service"
brew services start borders

# make zsh the default shell (already in /etc/shells, ships with macOS)
echo "setting zsh as default shell"

chsh -s /bin/zsh

# secrets
echo
echo "One manual step left: store the Jira personal access token in the Keychain."
echo "Nothing secret is kept in this repo, so each machine needs this once."
echo "Omitting the value after -w makes security prompt for it, which keeps the"
echo "token out of argv and out of your shell history:"
echo
echo '    security add-generic-password -s jira-pat -a "$USER" -w'
echo
echo "The jira() wrapper in common/config/zsh/secrets.zsh reads it on first use."
echo

echo "You can now launch aerospace!"
echo "Some changes will need a reboot such as default shell"