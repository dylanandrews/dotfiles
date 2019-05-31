# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

PATH=/usr/local/bin:$PATH
PATH=/usr/local/opt/ruby/bin:$PATH

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

# NPM
export PREFIX=$HOME/.npm-packages

NPM_PACKAGES="$HOME/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"

# Ruby Gems
GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/ # mysql2 missing library fix

# AWS CLI
export PATH=~/bin:$PATH

# EB CLI
export PATH=~/Library/Python/2.7/bin:$PATH

# GN API
export RACK_ENV='development'

# ANDROID STUDIO
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# FASTLANE
export PATH="$HOME/.fastlane/bin:$PATH"

export -U PATH
