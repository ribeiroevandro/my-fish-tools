function __clone_validate_url --description "Validate that a URL starts with git@ or https://"
    string match -qr '^(git@|https://)' $argv[1]
end
