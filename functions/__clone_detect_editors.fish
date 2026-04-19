function __clone_detect_editors --description "Detect installed editors via Applications, .desktop files and PATH"
    set -l found

    for entry in (__clone_known_editors)
        set -l parts (string split ":" $entry)
        set -l cmd $parts[1]
        set -l display $parts[4]

        contains $cmd $found; and continue

        set -l installed false

        # macOS: check /Applications for GUI editors
        if test -n "$parts[2]"; and test -d "/Applications/$parts[2].app"
            type -q $cmd; and set installed true
        end

        # Linux: check .desktop files
        if test "$installed" = false; and test -n "$parts[3]"; and test -f "/usr/share/applications/$parts[3].desktop"
            type -q $cmd; and set installed true
        end

        # Cross-platform: check PATH
        if test "$installed" = false
            type -q $cmd; and set installed true
        end

        if test "$installed" = true
            set -a found $cmd
            echo "$display:$cmd"
        end
    end
end
