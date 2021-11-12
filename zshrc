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

# Syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Make autocomplete case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export ERL_AFLAGS="-kernel shell_history enabled"

export PATH="/Users/dylanandrews/.rbenv/shims:$PATH"
export PATH="/Users/dylanandrews/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# asdf
. $HOME/.asdf/asdf.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias awsume=". awsume"
