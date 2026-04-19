function clone --description "Clone a git repository, optionally cd into it and open in an editor"
    type -q gum; or begin
        echo "Error: gum is required. Install with: brew install gum" >&2
        return 127
    end

    argparse C/enter h/help -- $argv
    or return 2

    if set -q _flag_help; or test (count $argv) -eq 0
        echo "Usage: clone <url> [folder] [editor] [options]"
        echo ""
        echo "Arguments:"
        echo "  url       Repository URL — git@ or https:// (required)"
        echo "  folder    Target directory name (default: repo name)"
        echo "  editor    Editor to open project after cloning"
        echo ""
        echo "Options:"
        echo "  -C, --enter   cd into directory after cloning"
        echo "  -h, --help    Show this help"
        echo ""
        echo "Examples:"
        echo "  clone https://github.com/user/repo"
        echo "  clone git@github.com:user/repo my-folder --enter code"
        return 0
    end

    set -l repo_url $argv[1]
    set -l editor ""
    set -l repo_name ""
    set -l should_enter false

    if set -q _flag_enter
        set should_enter true
    end

    __clone_validate_url $repo_url; or begin
        echo "Error: invalid URL. Use git@ or https:// format" >&2
        return 1
    end

    # Parse remaining args: known editor names vs custom folder name
    set -l known_cmds
    for entry in (__clone_known_editors)
        set -l parts (string split ":" $entry)
        set -a known_cmds $parts[1]
    end

    for arg in $argv[2..]
        if contains $arg $known_cmds
            set editor $arg
        else
            set repo_name $arg
        end
    end

    # Validate that the specified editor is installed; fallback to interactive selection
    if test -n "$editor"; and not type -q $editor
        echo "Error: editor '$editor' is not installed" >&2
        set -l detected (__clone_detect_editors)
        if test (count $detected) -gt 0
            set -l choices Skip
            for pair in $detected
                set -l p (string split ":" $pair)
                set -a choices "$p[1] ($p[2])"
            end
            set -l selected (printf "%s\n" $choices | gum choose --header "Available editors:")
            if test $status -ne 0
                return 0
            end
            if test -n "$selected"; and test "$selected" != Skip
                set editor (string match -r '\((\S+)\)$' $selected)[2]
            else
                set editor ""
            end
        else
            echo "No editors found on your system" >&2
            return 127
        end
    end

    if test -z "$repo_name"
        set repo_name (__clone_extract_repo_name $repo_url)
    end

    # Prompt for editor if not specified
    if test -z "$editor"
        set -l detected (__clone_detect_editors)
        set -l choices Skip
        for pair in $detected
            set -l p (string split ":" $pair)
            set -a choices "$p[1] ($p[2])"
        end
        set -l selected (printf "%s\n" $choices | gum choose --header "Open in which editor?")

        # User cancelled with Ctrl+C or Esc
        if test $status -ne 0
            return 0
        end

        if test -n "$selected"; and test "$selected" != Skip
            set editor (string match -r '\((\S+)\)$' $selected)[2]
        end
    end

    # If directory exists, offer git pull instead
    if test -d $repo_name
        echo "'$repo_name' already exists."
        if gum confirm "Pull latest changes?"
            gum spin --spinner dot --title "Updating $repo_name..." -- git -C $repo_name pull
            or return 1
        else
            return 0
        end
    else
        gum spin --spinner dot --title "Cloning $repo_name..." -- git clone $repo_url $repo_name
        or return 1
        echo "$repo_name cloned successfully."
    end

    if test "$should_enter" = false
        if gum confirm "Enter the directory?"
            set should_enter true
        end
    end

    if test "$should_enter" = true
        cd $repo_name
    end

    if test -n "$editor"
        if test "$should_enter" = true
            $editor .
        else
            $editor $repo_name
        end
    end
end
