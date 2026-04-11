function __runner_list_scripts
    test -f package.json; or return 1
    jq -r '(.scripts // {}) | keys[]' package.json 2>/dev/null
end

function __runner_detect_runner
    if test -f pnpm-lock.yaml
        echo pnpm
    else if test -f yarn.lock
        echo yarn
    else if test -f bun.lockb
        echo bun
    else
        echo npm
    end
end

function r --description "Run a script in the current project"
    # Check dependencies
    type -q jq; or begin
        echo "Error: jq is required. Install with: brew install jq"
        return 127
    end
    type -q gum; or begin
        echo "Error: gum is required. Install with: brew install gum"
        return 127
    end

    test -f package.json; or begin
        echo "package.json not found (run at project root)"
        return 1
    end

    set runner (__runner_detect_runner)
    set script_name $argv[1]

    # r dev
    if test -n "$script_name"
        set exists (jq -r --arg script_name "$script_name" '.scripts[$script_name] // empty' package.json)

        if test -z "$exists"
            echo "Script '$script_name' not found"
            return 1
        end

        # Forward remaining arguments to the runner
        $runner run $script_name $argv[2..-1]
        return
    end

    # r -> gum choose
    set scripts (__runner_list_scripts)

    # Check if any scripts exist
    if test (count $scripts) -eq 0
        echo "No scripts found in package.json"
        return 1
    end

    set selected (printf "%s\n" $scripts | gum choose --header "Select script")

    if test -n "$selected"
        $runner run $selected
    end
end
