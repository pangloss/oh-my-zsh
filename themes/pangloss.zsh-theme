function git_base_dir {
  base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
  if [ -n "$base_dir" ]; then
    base_dir=`cd $base_dir; pwd`
  else
    base_dir=$PWD
  fi
  echo "$(basename "${base_dir}")"
}

function git_sub_dir() {
  sub_dir=$(git rev-parse --show-prefix 2>/dev/null)
  if [ "${sub_dir%/}" ]; then
    echo "/${sub_dir%/}"
  else
    echo ""
  fi
}

function current_subpath() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
    echo $(git_base_dir)$(git_sub_dir)
  else
    echo $PWD
  fi
}

local colon="%{$fg[blue]%}:%{$reset_color%}"
PROMPT='%n$colon$RUBY_VERSION %{$fg[blue]%}➜%{$reset_color%} $(git_prompt_info)%{$fg_bold[white]%}$(current_subpath) $ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ⚡%{$fg[green]%}) %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}) %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[yellow]%} ↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[yellow]%} ↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%} ↕%{$reset_color%}"
