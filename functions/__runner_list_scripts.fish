function __runner_list_scripts --description "Extract available scripts from package.json"
    test -f package.json; or return 1
    set -l scripts (jq -r '(.scripts // {}) | keys[]' package.json 2>/dev/null)

    # Check if jq succeeded
    if test $status -ne 0
        echo "Error: Failed to parse package.json" >&2
        return 2
    end

    # Output scripts (empty if none)
    test -n "$scripts"; and printf "%s\n" $scripts
end
