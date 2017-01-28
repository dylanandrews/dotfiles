# Colors from http://wiki.archlinux.org/index.php/Color_Bash_Prompt
NO_COLOR='\e[0m' #disable any colors
# regular colors
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc" # Load the default .bashrc

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

export PS1="\[$CYAN\]\u\[$NO_COLOR\]@\h \W\[$GREEN\]\$(parse_git_branch)\[$NO_COLOR\] \n$ "

# This allows me to do all of these rake tasks with one command.
alias resetdb="bundle exec rake log:clear db:reset && bundle exec rake db:test:prepare && redis-cli flushall"
alias resetdbf="FULL=1 bundle exec rake log:clear db:reset && bundle exec rake db:test:prepare && redis-cli flushall"
alias co='checkout'
alias pull='pull origin'
alias st='status'
alias ci='commit'
alias br='branch'

export PATH=~/bin:$PATH
export PATH=~/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
