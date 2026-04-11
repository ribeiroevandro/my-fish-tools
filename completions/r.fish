function __runner_complete_with_gum
    if test -f package.json
        set scripts (jq -r '.scripts | keys[]' package.json 2>/dev/null)
        if test -n "$scripts"
            printf "%s\n" $scripts | gum choose --header "Select script"
        end
    end
end

complete -c r -f -a "(__runner_complete_with_gum)"
complete -c run -f -a "(__runner_complete_with_gum)"
