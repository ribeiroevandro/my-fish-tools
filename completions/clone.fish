complete -c clone -f
complete -c clone -s C -l enter -d "Enter directory after cloning"
complete -c clone -s h -l help -d "Show usage"

function __clone_complete_editors
    for pair in (__clone_detect_editors)
        set -l parts (string split ":" $pair)
        echo $parts[2]
    end
end

complete -c clone -n 'not __fish_is_nth_token 1' -a "(__clone_complete_editors)" -d "Editor"
