# Contributing to my-fish-tools

This is a simple Fish shell package. Guidelines for adding new utilities.

## Adding a New Function

1. Create a new file in `functions/` directory
2. Name it after the function: `my_function.fish`
3. Structure:

```fish
function my_function --description "What this does"
    # Your code here
end
```

4. If you have helper functions, use the repository convention: double underscore plus plugin prefix.
   Each helper should be in its own autoload file under `functions/`:

```fish
# functions/__my_plugin_helper.fish
function __my_plugin_helper --description "Helper logic"
    # Helper logic
end
```

This enables Fish's native autoloading and avoids duplication in completions.

**Example: Clone plugin structure**

```
functions/clone.fish                     # Main function
functions/__clone_known_editors.fish     # Helper 1 (one file per helper)
functions/__clone_detect_editors.fish    # Helper 2
functions/__clone_validate_url.fish      # Helper 3
functions/__clone_extract_repo_name.fish # Helper 4
```

5. Add completion in `completions/my_function.fish` if needed:

```fish
complete -c my_function -f -d "Description"
complete -c my_function -s h -d "Help"
```

## Testing

Before submitting:

```bash
fish -n functions/my_function.fish    # Check syntax
fish -c "source functions/my_function.fish; my_function --help"  # Test manually
```

## Documentation

Update README.md with:

- Function name and description
- Usage example
- External dependencies (if any)

## Code Style

- Use `set -l` for local variables (not used outside function)
- Use `set -g` for globals if necessary
- Comment complex logic
- Keep functions focused - one job per function
- Use meaningful variable names
