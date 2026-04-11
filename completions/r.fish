function __runner_complete_with_gum
    # Guard against missing dependencies
    type -q jq; or return 1
    type -q gum; or return 1

    if test -f package.json
        set scripts (jq -r '(.scripts // {}) | keys[]' package.json 2>/dev/null)
        if test -n "$scripts"
            printf "%s\n" $scripts | gum choose --header "Select script"
        end
    end
end

complete -c r -f -a "(__runner_complete_with_gum)"
complete -c run -f -a "(__runner_complete_with_gum)"
