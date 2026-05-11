# Auto-switch to zsh in Codespaces (SSH sessions ignore chsh)
if [ -n "$CODESPACES" ] && [ -z "$ZSH_VERSION" ] && command -v zsh &> /dev/null; then
    exec zsh -l
fi

[ -n "$PS1" ] && source ~/.bash_profile;

# npm global bin (Codex CLI lives here on Linux DevPods because install.sh
# sets `npm config set prefix "$HOME/.npm-global"`). Defensive guard so this
# is a no-op on machines without the directory.
[[ -d "$HOME/.npm-global/bin" ]] && export PATH="$HOME/.npm-global/bin:$PATH"

# git-ai shim — cross-platform (works on Mac AND Linux DevPods).
[[ -d "$HOME/.git-ai/bin" ]] && export PATH="$HOME/.git-ai/bin:$PATH"
