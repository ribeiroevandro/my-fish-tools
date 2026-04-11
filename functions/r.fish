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
        echo "Error: jq is required. Install it with your system package manager (see README for platform-specific instructions)."
        return 127
    end
    type -q gum; or begin
        echo "Error: gum is required. Install it with your system package manager (see README for platform-specific instructions)."
        return 127
    end

    test -f package.json; or begin
        echo "package.json not found (run at project root)"
        return 1
    end

    set -l runner (__runner_detect_runner)
    
    # Verify detected runner is installed
    type -q $runner; or begin
        echo "Error: detected package runner '$runner' is not installed or not in PATH"
        echo "Install '$runner' or use the package manager that matches this project's lockfile"
        return 127
    end
    
    set -l script_name $argv[1]

    # r dev
    if test -n "$script_name"
        set -l exists (jq -r --arg script_name "$script_name" '.scripts[$script_name] // empty' package.json)

        if test -z "$exists"
            echo "Script '$script_name' not found"
            return 1
        end

        # Forward remaining arguments to the runner
        # npm/pnpm/bun need -- separator; yarn doesn't
        if test (count $argv) -gt 1
            if test "$runner" = yarn
                $runner run $script_name $argv[2..-1]
            else
                $runner run $script_name -- $argv[2..-1]
            end
        else
            $runner run $script_name
        end
        return
    end

    # r -> gum choose
    set -l scripts (__runner_list_scripts)

    # Check if any scripts exist
    if test (count $scripts) -eq 0
        echo "No scripts found in package.json"
        return 1
    end

    set -l selected (printf "%s\n" $scripts | gum choose --header "Select script")
    set -l choose_status $status

    # User cancelled selection or error; do not treat as error on cancel
    if test $choose_status -ne 0
        return 0
    end

    if test -n "$selected"
        $runner run $selected
    end
end
