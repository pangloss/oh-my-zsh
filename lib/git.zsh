# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_divergence)$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

parse_git_dirty () {
  if [[ $((git status 2> /dev/null) | tail -n1) != "nothing to commit (working directory clean)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

parse_git_divergence() {
  git_status="$(git status 2> /dev/null)"
  # would be more optimized to do status here...
  #if [[ ! ${git_status}} =~ "working directory clean" ]]; then
    #echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  #else
    #echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  #fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ "# Your branch is (ahead|behind)" ]]; then
    if [[ ${MATCH[-5,-1]} == "ahead" ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
    else
      echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
    fi
  elif [[ ${git_status} =~ "# Your branch and (.*) have diverged" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi
}


#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# Aliases
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gdc='git diff --cached'
alias gr="git remote -v"
