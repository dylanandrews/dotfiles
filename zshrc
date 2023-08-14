# ssh dylanandrews@dylanandrewsmbp.attlocal.net
autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
source ~/.bash_profile
source ~/.bashrc
eval "$(nodenv init -)"
compdef _git stripe-git=git # this line specifically will fix git autocompletion

# Load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

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

export PATH="/Users/dylanandrews/.rbenv/shims:$PATH"
export PATH="/Users/dylanandrews/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Starship prompt
# eval "$(starship init zsh)"

# asdf
. $HOME/.asdf/asdf.sh

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

source /Users/dylanandrews/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# export PATH="$PATH:$HOME/stripe/work/exe"
# source /opt/homebrew/opt/gitstatus/gitstatus.prompt.zsh
