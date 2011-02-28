#compdef rvm
# zsh completion for rvm

_rvm() {
    local curcontext="$curcontext" state line expl ret=1

    _arguments -C \
        '-S[look for the script using PATH environment variable]' \
        "-e[one line of script. Several -e's allowed. Omit \[programfile\]]" \
        '(-v --version)'{-v,--version}'[Emit rvm version loaded for current shell]' \
        '(-h --help)'{-h,--help}'[Emit this output and exit]' \
        '1: :->cmds' \
        '*:: :->args' && return 0

    if [[ -n $state ]]; then
        typeset -A _rvm_actions
        _rvm_actions=(
                # usage     'show this usage information'
                use       'setup current shell to use a specific ruby version'
                info      'show information for current ruby'
                list      'show currently installed versions'
                reload    'reload rvm source itself (useful after changing rvm source)'
                implode   'removes all ruby installations it manages, everything in ~/.rvm'
                update    'upgrades rvm to the latest version.'
                reset     'remove default and current settings, exit the shell.'
                debug     'emit environment & configuration information for *current* ruby'
                install   'install one or many ruby versions'
                uninstall 'uninstall one or many ruby versions, leaves their sources'
                remove    'uninstall one or many ruby versions and remove their sources'
                rm        'uninstall one or many ruby versions and remove their sources'
                ruby      'runs a named ruby file against specified and/or all rubies'
                gem       "runs a gem command using selected ruby's 'gem'"
                rake      'runs a rake task against specified and/or all rubies'
                tests     "runs 'rake test' across selected ruby versions"
                specs     "runs 'rake spec' across selected ruby versions"
                gemdir    'switch to gem directory for installation (new login shell)'
                gemset    'gemset commands'
                srcdir    'switch to src directory for the current ruby installation'
                all       ''
                default   ''
                benchmark 'rvm ruby[,rubies...] benchmark programfile'
                bench     'rvm ruby[,rubies...] benchmark programfile'
                inspect   ''
                monitor   'rvm ruby[,rubies...] monitor'
        )
    fi

    case $state in
        cmds)
            _rvm_installed_rubies
            _rvm_compl_action
            return 0
            ;;
        args)
            local cmd arg

            if [ ${+_rvm_actions[$words[1]]} -eq 1 ]; then
                cmd=$words[1]
                curcontext="${curcontext%:*:*}:rvm-${cmd}:"

                _message "${_rvm_actions[$cmd]}"
                case $cmd in;
                    (install)
                    _rvm_compl_install && return 0
                    ;;
                    (update)
                    _arguments -C \
                        '(--rubygems)--head[updates rvm to git head version.]' \
                        '(--head)--rubygems[updates rubygems for selected ruby.]' \
                        && return 0
                    ;;
                    (uninstall|remove|use)
                    _arguments ":rubies:_rvm_installed_rubies" && return 0
                    ;;
                    (gemset)
                    _arguments ":gemset_commands:_rvm_gemset_commands" && return 0
                    ;;
                esac
            fi
            ;;
    esac
}

_rvm_gemset_commands()
{
  local gemset_commands
  typeset -a gemset_commands
  gemset_commands=(list use)
  _wanted gemset_commands expl 'gemset_commands' compadd -- "$gemset_commands[@]"
}

_rvm_installed_rubies()
{
    local rubies
    typeset -a rubies
    # `rvm list' is so slow...
    rubies=(
        $(_call_program options rvm list strings)
        system
        default
    )
    _wanted rubies expl 'rubies' compadd -- "$rubies[@]"
}

_rvm_installable_rubies()
{
    local rubies
    typeset -a rubies
    # `rvm list known' is so slow...
    if [ ! -e $rvm_path/list_all.txt ]; then
        _call_program options rvm list known | sed -e 's/#.*$//g' | sed -e 's/(.*-)//g' | sed -e 's/(-.*)//g' | sed -e '/^$/d' > $rvm_path/list_all.txt
    fi
    rubies=(
        $(_call_program options cat $rvm_path/list_all.txt)
    )
    _wanted rubies expl 'rubies' compadd -- "$rubies[@]"
}

_rvm_compl_action()
{
    _wanted actions expl 'action' compadd -k _rvm_actions
}

_rvm_compl_install()
{
    _arguments ":rubies:_rvm_installable_rubies" ":options:_rvm_compl_install_options"
}

_rvm_compl_install_options()
{
    local options
    typeset -a options
    options=(
        --force --reconfigure --make --make-install --nice
    )
    case $words[2] in;
        ree*)
            options=($options --ree-options)
        ;;
        rbx*)
            options=($options --jit)
        ;;
    esac
    _wanted options expl 'options' compadd -- "$options[@]"
}

#_rvm "$@"
# Local Variables:
# mode: shell-script
# End:
compdef _rvm rvm
