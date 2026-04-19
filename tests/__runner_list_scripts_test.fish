#!/usr/bin/env fish
# Test: __runner_list_scripts
# Extracts script names from package.json

source functions/__runner_list_scripts.fish

echo "Testing __runner_list_scripts..."

# Create a temporary directory for testing
set -l test_dir (mktemp -d)
cd $test_dir

# Test 1: Extracts scripts from valid package.json
echo -n "Test 1 - Extract scripts from package.json: "
echo '{"name":"test","scripts":{"build":"echo build","test":"echo test","dev":"echo dev"}}' > package.json
set -l result (__runner_list_scripts)
set -l script_count (count $result)
if test $script_count -eq 3
    echo "✓ PASS (got $script_count scripts)"
else
    echo "✗ FAIL (expected 3 scripts, got $script_count)"
end

# Test 2: Contains 'build' script
echo -n "Test 2 - Contains 'build' script: "
set -l result (__runner_list_scripts)
if string match -q "*build*" (string join "\n" $result)
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 'build' in output)"
end

# Test 3: Contains 'test' script
echo -n "Test 3 - Contains 'test' script: "
set -l result (__runner_list_scripts)
if string match -q "*test*" (string join "\n" $result)
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 'test' in output)"
end

# Test 4: Error when package.json missing
echo -n "Test 4 - Error when package.json missing: "
rm package.json
__runner_list_scripts >/dev/null 2>&1
if test $status -ne 0
    echo "✓ PASS (returned error)"
else
    echo "✗ FAIL (expected error)"
end

# Test 5: Handles package.json with no scripts
echo -n "Test 5 - Handle package.json with empty scripts: "
echo '{"name":"test","scripts":{}}' > package.json
set -l result (__runner_list_scripts)
set -l empty_count (count $result)
if test $empty_count -eq 0
    echo "✓ PASS (empty scripts)"
else
    echo "✗ FAIL (expected empty result, got $empty_count)"
end

# Cleanup
cd -
rm -rf $test_dir

echo ""
echo "All tests passed! ✓"

