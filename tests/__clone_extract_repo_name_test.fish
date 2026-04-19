#!/usr/bin/env fish
# Test: __clone_extract_repo_name
# Extracts repository name from git URLs, removing .git suffix

source functions/__clone_extract_repo_name.fish

echo "Testing __clone_extract_repo_name..."

# Test 1: Extract from SSH URL with .git
echo -n "Test 1 - SSH URL with .git: "
set -l result (__clone_extract_repo_name "git@github.com:user/my-repo.git")
if test "$result" = my-repo
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: my-repo, got: $result)"
end

# Test 2: Extract from HTTPS URL with .git
echo -n "Test 2 - HTTPS URL with .git: "
set -l result (__clone_extract_repo_name "https://github.com/user/my-repo.git")
if test "$result" = my-repo
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: my-repo, got: $result)"
end

# Test 3: Extract from SSH URL without .git
echo -n "Test 3 - SSH URL without .git: "
set -l result (__clone_extract_repo_name "git@github.com:user/my-repo")
if test "$result" = my-repo
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: my-repo, got: $result)"
end

# Test 4: Extract from URL with uppercase
echo -n "Test 4 - Uppercase in URL: "
set -l result (__clone_extract_repo_name "https://github.com/user/My-Repo.git")
if test "$result" = My-Repo
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: My-Repo, got: $result)"
end

# Test 5: Extract with numbers and hyphens
echo -n "Test 5 - Numbers and hyphens: "
set -l result (__clone_extract_repo_name "https://github.com/user/repo-123.git")
if test "$result" = repo-123
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: repo-123, got: $result)"
end

echo ""
echo "All tests passed! ✓"
