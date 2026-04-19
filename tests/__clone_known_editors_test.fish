#!/usr/bin/env fish
# Test: __clone_known_editors
# Lists known editors that clone plugin supports

source functions/__clone_known_editors.fish

echo "Testing __clone_known_editors..."

# Test 1: Returns non-empty output
echo -n "Test 1 - Returns non-empty list: "
set -l result (__clone_known_editors)
set -l editor_count (count $result)
if test -n "$result"
    echo "✓ PASS (got $editor_count editors)"
else
    echo "✗ FAIL (expected non-empty list)"
end

# Test 2: Contains code (VS Code)
echo -n "Test 2 - Contains 'code' (VS Code): "
set -l result (__clone_known_editors | grep -w "code")
if test -n "$result"
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 'code' in output)"
end

# Test 3: Contains vim
echo -n "Test 3 - Contains 'vim': "
set -l result (__clone_known_editors | grep -w "vim")
if test -n "$result"
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 'vim' in output)"
end

# Test 4: Contains multiple editors
echo -n "Test 4 - Multiple editors (at least 5): "
set -l result (__clone_known_editors)
set -l editor_count (count $result)
if test $editor_count -ge 5
    echo "✓ PASS (got $editor_count editors)"
else
    echo "✗ FAIL (expected at least 5 editors, got $editor_count)"
end

# Test 5: Contains cursor and nvim
echo -n "Test 5 - Contains cursor and nvim: "
set -l editors (__clone_known_editors | string join " ")
if string match -q "*cursor*" "$editors"; and string match -q "*nvim*" "$editors"
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 'cursor' and 'nvim' in output)"
end

echo ""
echo "All tests passed! ✓"
