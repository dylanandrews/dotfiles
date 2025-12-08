#!/bin/bash
# install.sh - GitHub Codespaces compatible dotfiles installer
# This script is automatically run by GitHub Codespaces when creating a new codespace
# It also works on any Linux/macOS system

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🔧 Installing dotfiles from $DOTFILES_DIR..."

# Function to safely symlink files
link_file() {
    local src="$1"
    local dest="$2"

    if [ -f "$src" ]; then
        # Backup existing file if it's not a symlink
        if [ -f "$dest" ] && [ ! -L "$dest" ]; then
            echo "  📦 Backing up existing $dest to $dest.backup"
            mv "$dest" "$dest.backup"
        fi

        ln -sf "$src" "$dest"
        echo "  ✓ Linked $dest"
    fi
}

# Function to safely symlink directories
link_dir() {
    local src="$1"
    local dest="$2"

    if [ -d "$src" ]; then
        if [ -d "$dest" ] && [ ! -L "$dest" ]; then
            echo "  📦 Backing up existing $dest to $dest.backup"
            mv "$dest" "$dest.backup"
        fi

        ln -sf "$src" "$dest"
        echo "  ✓ Linked $dest"
    fi
}

echo ""
echo "📁 Linking shell configuration..."
link_file "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
link_file "$DOTFILES_DIR/bash_profile" "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/aliases" "$HOME/.aliases"

echo ""
echo "📁 Linking git configuration..."
link_file "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/gitmessage" "$HOME/.gitmessage"

echo ""
echo "📁 Linking editor configuration..."
link_file "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/ideavimrc" "$HOME/.ideavimrc"

echo ""
echo "📁 Linking tool configuration..."
link_file "$DOTFILES_DIR/gemrc" "$HOME/.gemrc"
link_file "$DOTFILES_DIR/rspec" "$HOME/.rspec"
link_file "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo ""
echo "📁 Linking directories..."
link_dir "$DOTFILES_DIR/bin" "$HOME/bin"
link_dir "$DOTFILES_DIR/tmuxinator" "$HOME/.tmuxinator"
link_dir "$DOTFILES_DIR/zsh" "$HOME/.zsh"

# Claude Code settings
if [ -d "$DOTFILES_DIR/.claude" ]; then
    echo ""
    echo "📁 Linking Claude Code configuration..."
    mkdir -p "$HOME/.claude"
    for file in "$DOTFILES_DIR/.claude"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            link_file "$file" "$HOME/.claude/$filename"
        fi
    done
fi

# Ensure starship config directory exists
mkdir -p "$HOME/.config"

# Install zsh-autosuggestions if not present (and if oh-my-zsh is installed)
if [ -d "$HOME/.oh-my-zsh" ] && [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo ""
    echo "💻 Installing zsh-autosuggestions..."
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
fi

echo ""
echo "✅ Dotfiles installed successfully!"
echo ""
echo "Note: You may need to restart your shell or run 'source ~/.zshrc' for changes to take effect."
