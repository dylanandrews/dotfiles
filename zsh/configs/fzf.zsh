# fzf configuration
# Source fzf key bindings and completion from Homebrew installation

# Source fzf key bindings (^R for history, ^T for files, ALT-C for cd)
if [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Source fzf completion
if [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Default fzf options
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"

# Use fd instead of find if available for better performance and respects .gitignore
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
