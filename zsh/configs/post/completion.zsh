# Warp handles its own completion — skip compinit to avoid ZLE conflicts
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  # load our own completion functions
  fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

  # completion
  autoload -U compinit
  compinit
fi
