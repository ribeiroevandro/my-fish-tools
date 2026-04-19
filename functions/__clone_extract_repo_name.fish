function __clone_extract_repo_name --description "Extract the repository folder name from a URL"
    basename $argv[1] .git
end
