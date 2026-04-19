function __runner_complete_with_gum
    type -q jq; or return 1
    type -q gum; or return 1

    set -l scripts (__runner_list_scripts)
    if test (count $scripts) -gt 0
        printf "%s\n" $scripts | gum choose --header "Select script"
    end
end

complete -c r -f -a "(__runner_complete_with_gum)"
complete -c run -f -a "(__runner_complete_with_gum)"
