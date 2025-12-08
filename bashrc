# Auto-switch to zsh in Codespaces (SSH sessions ignore chsh)
if [ -n "$CODESPACES" ] && [ -z "$ZSH_VERSION" ] && command -v zsh &> /dev/null; then
    exec zsh -l
fi

[ -n "$PS1" ] && source ~/.bash_profile;
