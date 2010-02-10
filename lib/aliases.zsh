#!/bin/zsh

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Rails
alias s='thin --stats "/thin/stats" start'
alias c='ruby script/console'
alias sc='ruby script/console'
alias scprod='script/console production'
alias sd='ruby script/server --debugger'
alias devlog='tail -f log/development.log'
alias migrate='rake db:migrate'
alias unmigrate='rake db:rollback'
alias cuc="cat tmp/cucumber | xargs cucumber --format progress --format rerun --out tmp/cucumber"

# Basic directory operations
alias .='pwd'
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -alr'
alias sl=ls # often screw this up

# Find ruby file
alias rfind='find . -name *.rb | xargs grep -n'
alias afind='ack-grep -il'
