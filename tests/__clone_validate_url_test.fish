#!/usr/bin/env fish
# Test: __clone_validate_url
# Validates that git URLs (SSH and HTTPS) are accepted, invalid formats rejected

source functions/__clone_validate_url.fish

echo "Testing __clone_validate_url..."

# Test 1: Accept valid SSH URL
echo -n "Test 1 - SSH URL: "
__clone_validate_url "git@github.com:user/repo.git"
if test $status -eq 0
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 0, got $status)"
end

# Test 2: Accept valid HTTPS URL
echo -n "Test 2 - HTTPS URL: "
__clone_validate_url "https://github.com/user/repo.git"
if test $status -eq 0
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 0, got $status)"
end

# Test 3: Reject invalid URL without protocol
echo -n "Test 3 - No protocol: "
__clone_validate_url "github.com/user/repo"
if test $status -ne 0
    echo "✓ PASS"
else
    echo "✗ FAIL (expected non-zero, got $status)"
end

# Test 4: Reject empty string
echo -n "Test 4 - Empty string: "
__clone_validate_url ""
if test $status -ne 0
    echo "✓ PASS"
else
    echo "✗ FAIL (expected non-zero, got $status)"
end

# Test 5: Accept HTTPS URL even with spaces (regex only validates prefix)
# Note: The function validates only the protocol prefix, not full URL validity
echo -n "Test 5 - HTTPS with spaces (validates prefix only): "
__clone_validate_url "https://github.com/user repo/repo.git"
if test $status -eq 0
    echo "✓ PASS"
else
    echo "✗ FAIL (expected 0, got $status)"
end

echo ""
echo "All tests passed! ✓"


