# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# Pure prompt
autoload -U promptinit; promptinit
prompt pure

# completion
autoload -U compinit
compinit
