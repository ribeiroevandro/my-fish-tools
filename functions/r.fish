function __runner_list_scripts
    test -f package.json; or return 1
    jq -r '.scripts | keys[]' package.json
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
    test -f package.json; or begin
        echo "package.json not found (run at project root)"
        return 1
    end

    set runner (__runner_detect_runner)
    set script_name $argv[1]

    # r dev
    if test -n "$script_name"
        set exists (jq -r ".scripts[\"$script_name\"] // empty" package.json)

        if test -z "$exists"
            echo "Script '$script_name' not found"
            return 1
        end

        $runner run $script_name
        return
    end

    # r -> gum choose
    set scripts (__runner_list_scripts)

    set selected (printf "%s\n" $scripts | gum choose --header "Select script")

    if test -n "$selected"
        $runner run $selected
    end
end
