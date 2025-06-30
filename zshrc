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

# add pip to path
export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Show path in iterm tab
if [ $ITERM_SESSION_ID ]; then
precmd() {
  echo -ne "\033]0;${PWD##*/}\007"
}
fi

# Pure prompt
fpath+=("$(brew --prefix)/share/zsh/site-functions")

autoload -U promptinit; promptinit

# optionally define some options
PURE_CMD_MAX_EXEC_TIME=10

# # change the path color
zstyle :prompt:pure:path color 205

# change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color cyan

zstyle :prompt:pure:git:branch color 069
zstyle :prompt:pure:git:branch:cached color 069

prompt pure
# end of pure prompt info

source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"

# For python for AI course
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

eval "$(mise activate zsh)"
