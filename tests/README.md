# Tests

Test suite for my-fish-tools.

## Running Tests

Run individual test file:

```bash
fish tests/__clone_validate_url_test.fish
```

Run all tests:

```bash
for test in tests/*_test.fish
    echo "Running $test..."
    fish "$test"
end
```

Or with a simple shell script:

```bash
#!/bin/bash
cd my-fish-tools
for test in tests/*_test.fish; do
    echo "Running $test..."
    fish "$test" || exit 1
done
echo "All tests passed!"
```

## Test Coverage

| Module                      | Tests                     | Status         |
| --------------------------- | ------------------------- | -------------- |
| `__clone_validate_url`      | URL validation            | ✅ Implemented |
| `__clone_extract_repo_name` | Name extraction           | ⏳ Pending     |
| `__clone_known_editors`     | Editor listing            | ⏳ Pending     |
| `__clone_detect_editors`    | Editor detection          | ⏳ Pending     |
| `clone`                     | Integration               | ⏳ Pending     |
| `__runner_detect_runner`    | Package manager detection | ⏳ Pending     |
| `__runner_list_scripts`     | Script extraction         | ⏳ Pending     |
| `r`                         | Integration               | ⏳ Pending     |

## Writing Tests

Each test file follows the naming convention: `FUNCTION_test.fish`

Test files are executable Fish scripts that source the function and test it:

```fish
#!/usr/bin/env fish
# Test: function_name
# Description of what is being tested

source functions/FUNCTION.fish

echo "Testing function_name..."

# Test case 1
echo -n "Test 1 - Description: "
if FUNCTION arg1 arg2; and test $status -eq 0
    echo "✓ PASS"
else
    echo "✗ FAIL"
end

# Test case 2
echo -n "Test 2 - Description: "
if not FUNCTION invalid_arg
    echo "✓ PASS"
else
    echo "✗ FAIL"
end

echo ""
echo "All tests passed! ✓"
```

### Test Structure

- Add shebang: `#!/usr/bin/env fish`
- Source the function being tested
- Use `if`/`test` to verify behavior
- Print `✓ PASS` or `✗ FAIL` for each test
- Exit 0 on success, non-zero on failure

### Exit Codes (tested functions should return)

- `0` — Success
- `1` — User error
- `2` — Parse error
- `127` — Missing dependency

## Example: Complete Test

```fish
#!/usr/bin/env fish
source functions/__my_function.fish

echo "Testing __my_function..."

# Valid input
echo -n "Test 1 - Valid input: "
if __my_function "valid_arg" >/dev/null 2>&1; and test $status -eq 0
    echo "✓ PASS"
else
    echo "✗ FAIL"
end

# Invalid input
echo -n "Test 2 - Invalid input: "
if __my_function "invalid" >/dev/null 2>&1; and test $status -ne 0
    echo "✓ PASS"
else
    echo "✗ FAIL"
end

echo ""
echo "All tests passed! ✓"
```

## References

- [Issue #8: Add test suite](https://github.com/ribeiroevandro/my-fish-tools/issues/8)
- [Fish documentation](https://fishshell.com/docs/current/)
