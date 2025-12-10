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
link_file "$DOTFILES_DIR/bash_profile" "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/aliases" "$HOME/.aliases"

# Handle bashrc - don't modify in Codespaces (can break scripts that source it)
if [ -z "$CODESPACES" ]; then
    link_file "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
fi

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

# Codespaces-specific setup: install tools to match local Mac environment
if [ -n "$CODESPACES" ]; then
    echo ""
    echo "🖥️  Codespaces detected - installing additional tools..."

    # Set zsh as default shell
    if command -v zsh &> /dev/null; then
        echo "🐚 Setting zsh as default shell..."
        sudo chsh -s "$(which zsh)" "$(whoami)" 2>/dev/null || true
    fi

    # Install Pure prompt via npm
    if ! command -v prompt &> /dev/null; then
        echo "💜 Installing Pure prompt..."
        npm install --global pure-prompt 2>/dev/null || true
    fi

    # Install eza (modern ls replacement)
    if ! command -v eza &> /dev/null; then
        echo "📂 Installing eza..."
        sudo apt-get update -qq && sudo apt-get install -y -qq eza 2>/dev/null || true
    fi

    # Install zsh-syntax-highlighting via apt (more reliable than git clone)
    if ! dpkg -l zsh-syntax-highlighting &> /dev/null; then
        echo "🎨 Installing zsh-syntax-highlighting..."
        sudo apt-get install -y -qq zsh-syntax-highlighting
    fi

    # Create oh-my-zsh custom plugins directory
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"

    # Install zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "💡 Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
    fi

    # Setup Claude Code MCP configuration
    if [ -f "$DOTFILES_DIR/claude.json.template" ]; then
        echo ""
        echo "⚙️  Setting up Claude Code MCP configuration..."

        # Check if jq is available for JSON merging
        if ! command -v jq &> /dev/null; then
            echo "  📦 Installing jq for JSON merging..."
            sudo apt-get update -qq && sudo apt-get install -y -qq jq
        fi

        # Generate base config from template with environment variable substitution
        if command -v envsubst &> /dev/null; then
            envsubst < "$DOTFILES_DIR/claude.json.template" > "$HOME/.claude.json.template.tmp"
        else
            cp "$DOTFILES_DIR/claude.json.template" "$HOME/.claude.json.template.tmp"
        fi

        # If .claude.json already exists, merge MCP config into it
        if [ -f "$HOME/.claude.json" ]; then
            echo "  📝 Merging MCP configuration into existing Claude Code config..."

            # Extract settings from template
            TEMPLATE_MCPS=$(jq -r '.mcpServers' "$HOME/.claude.json.template.tmp")
            TEMPLATE_THEME=$(jq -r '.theme // empty' "$HOME/.claude.json.template.tmp")
            TEMPLATE_DISABLED_MCPS=$(jq -r '.disabledMcpServers // []' "$HOME/.claude.json.template.tmp")
            TEMPLATE_DISABLED_JSON_MCPS=$(jq -r '.disabledMcpjsonServers // []' "$HOME/.claude.json.template.tmp")

            # Merge into existing config (preserve all existing data, update from template)
            jq --argjson mcps "$TEMPLATE_MCPS" \
               --arg theme "$TEMPLATE_THEME" \
               --argjson disabledMcps "$TEMPLATE_DISABLED_MCPS" \
               --argjson disabledJsonMcps "$TEMPLATE_DISABLED_JSON_MCPS" \
               '. + {mcpServers: $mcps} + (if $theme != "" then {theme: $theme} else {} end) + {disabledMcpServers: $disabledMcps, disabledMcpjsonServers: $disabledJsonMcps}' \
               "$HOME/.claude.json" > "$HOME/.claude.json.new"

            mv "$HOME/.claude.json.new" "$HOME/.claude.json"
            echo "  ✅ MCP configuration merged (existing settings preserved)"
        else
            # Fresh install - use template as-is
            mv "$HOME/.claude.json.template.tmp" "$HOME/.claude.json"
            echo "  ✅ Claude Code configured (fresh install)"
        fi

        # Clean up temp file
        rm -f "$HOME/.claude.json.template.tmp"
    fi

else
    # Non-Codespaces: only install zsh plugins if oh-my-zsh exists
    if [ -d "$HOME/.oh-my-zsh" ] && [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo ""
        echo "💻 Installing zsh-autosuggestions..."
        mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
    fi
fi

echo ""
echo "✅ Dotfiles installed successfully!"
echo ""
echo "Note: You may need to restart your shell or run 'source ~/.zshrc' for changes to take effect."
