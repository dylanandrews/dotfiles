# Personal dotfiles

This is inspired by thoughtbot's [dotfiles](https://github.com/thoughtbot/dotfiles.git), as well as [David Calhoun's](https://github.com/dcalhoun/dotfiles). Constantly a work in progress.

## Install

1. Download Xcode and CLI utilities

1. [Setup SSH key with GitHub](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)

   Be sure to permanently add the key in `~/.ssh/config`

1. Clone and run setup script:

   ```
   git clone git@github.com:jchristianhall/dotfiles.git ~/.dotfiles
   ~/.dotfiles/setup.sh
   ```

## What's in it?

[git](http://git-scm.com/) configuration:

- Adds a `create-branch` alias to create feature branches.
- Adds a `delete-branch` alias to delete feature branches.
- Adds a `merge-branch` alias to merge feature branches into master.
- Adds an `up` alias to fetch and rebase `origin/master` into the feature
  branch. Use `git up -i` for interactive rebases.
- Adds lots of aliases for common commands.
- Makes output pretty with `diff-so-fancy`.
- Sets smart defaults for lots of things like `.gitignore`, etc.
- Add a fun gitmessage comment

[tmux](http://robots.thoughtbot.com/a-tmux-crash-course) configuration:

- Improve color resolution.
- Remove administrative debris (session name, hostname, time) in status bar.
- Set prefix to `Ctrl+j`
- Soften status bar color from harsh green to light gray.

[npm](https://www.npmjs.com) configuration:

- Remove need for using sudo by setting up npm to install to a specific global directory that doesn't need special permissions

[Ruby](https://www.ruby-lang.org/en/) configuration:

- Add trusted binstubs to the `PATH`.

Shell aliases and scripts:

- Adds some bash settings in case you don't wanna use zsh
- `g` with no arguments is `git status` and with arguments acts like `git`.
- `mcd` to make a directory and change into it.
- `v` for `$VISUAL`.

## Todo

- Manage VSCode in this repo?
- Manage MacOS system prefs with `.macos`
