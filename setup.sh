#!/bin/sh

DOTFILES=$HOME/.dotfiles
ASDF=$HOME/.asdf

# Install asdf
if [ ! -e $ASDF ]; then
  git clone https://github.com/asdf-vm/asdf.git $ASDF --branch v0.6.3
fi

# Install Homebrew packages
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle --file=${DOTFILES}/Brewfile

# Set zsh as default shell
chsh -s $(which zsh)

# Install npm
curl -L https://www.npmjs.org/install.sh | sh

# Install pure-prompt
yarn global add gulp-cli pure-prompt webpack-cli webpack-dev-server

# Install tmuxinator
gem install tmuxinator --install-dir $HOME/.gem

# Symlink dotfiles
env RCRC=${DOTFILES}/rcrc rcup -f

# Create Projects directory
if [ ! -e $HOME/Projects ]; then
  mkdir $HOME/Projects
fi
