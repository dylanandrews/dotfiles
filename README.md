# Personal dotfiles

## Install

1. Download Xcode and CLI utilities

2. [Setup SSH key with GitHub](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)

   Be sure to permanently add the key in `~/.ssh/config`

3. Clone and run setup script:

   ```
   git clone git@github.com:dylanandrews/dotfiles.git ~/.dotfiles

   ~/.dotfiles/setup.sh

   apm install --packages-file packages.txt
   ```

4. Notes on brew files
  * `fzf` - need to run `/usr/local/opt/fzf/install` after installing

7. `sudo vim ~/etc/hosts` file

8. Add [relaxed theme](https://github.com/Relaxed-Theme/relaxed-terminal-themes#installation-1) to iterm2 by dowloading the colors and then importing them into iterm.

## Mac Settings

1. Finder > View > Show Path

2. Finder > View > Show Status

3. Invert Scrolling

4. General > Always show scroll bar

```

## What's in it?
- Add trusted binstubs to the `PATH`.

Shell aliases and scripts:

- Adds some bash settings in case you don't wanna use zsh
- `g` with no arguments is `git status` and with arguments acts like `git`.
- `mcd` to make a directory and change into it.
- `v` for `$VISUAL`.

```
