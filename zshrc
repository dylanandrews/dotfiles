autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
compdef _git stripe-git=git # this line specifically will fix git autocompletion

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [ -f $config ]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Make autocomplete case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export ERL_AFLAGS="-kernel shell_history enabled"

# add pip to path (macOS only)
[[ -d "/Library/Frameworks/Python.framework/Versions/3.13/bin" ]] && export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"

# Show path in iterm tab
if [ $ITERM_SESSION_ID ]; then
precmd() {
  echo -ne "\033]0;${PWD##*/}\007"
}
fi

# Pure prompt (only on macOS with Homebrew)
if command -v brew &> /dev/null; then
    fpath+=("$(brew --prefix)/share/zsh/site-functions")
    autoload -U promptinit; promptinit

    # optionally define some options
    PURE_CMD_MAX_EXEC_TIME=10

    # change the path color
    zstyle :prompt:pure:path color 205

    # change the color for both `prompt:success` and `prompt:error`
    zstyle ':prompt:pure:prompt:*' color cyan

    zstyle :prompt:pure:git:branch color 069
    zstyle :prompt:pure:git:branch:cached color 069

    prompt pure
fi
# end of pure prompt info

# Oh-my-zsh plugins (only if installed)
[[ -f ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Temporarily unset PREFIX for NVM compatibility
unset PREFIX

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load local env if it exists
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

[[ -s "$HOME/.dotfiles/init.sh" ]] && source "$HOME/.dotfiles/init.sh"

# For python for AI course (only if pyenv is installed)
if command -v pyenv &> /dev/null || [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)" 2>/dev/null
    eval "$(pyenv init -)" 2>/dev/null
fi

# Mise (only if installed)
command -v mise &> /dev/null && eval "$(mise activate zsh)"
export PATH="$HOME/.local/bin:$PATH"
# export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"

export BUNDLE_RUBYGEMS__PKG__GITHUB_COM="$NODE_AUTH_TOKEN"

# Add libpq bin to PATH (for Ruby LSP PostgreSQL gem compilation) - macOS only
[[ -d "/opt/homebrew/opt/libpq/bin" ]] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
