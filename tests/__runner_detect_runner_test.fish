#!/usr/bin/env fish
# Test: __runner_detect_runner
# Auto-detects package manager from lockfiles

source functions/__runner_detect_runner.fish

echo "Testing __runner_detect_runner..."

# Create a temporary directory for testing
set -l test_dir (mktemp -d)
cd $test_dir

# Test 1: Detects pnpm from pnpm-lock.yaml
echo -n "Test 1 - Detects pnpm-lock.yaml: "
touch pnpm-lock.yaml
set -l result (__runner_detect_runner)
if test "$result" = pnpm
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: pnpm, got: $result)"
end
rm pnpm-lock.yaml

# Test 2: Detects yarn from yarn.lock
echo -n "Test 2 - Detects yarn.lock: "
touch yarn.lock
set -l result (__runner_detect_runner)
if test "$result" = yarn
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: yarn, got: $result)"
end
rm yarn.lock

# Test 3: Detects bun from bun.lockb
echo -n "Test 3 - Detects bun.lockb: "
touch bun.lockb
set -l result (__runner_detect_runner)
if test "$result" = bun
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: bun, got: $result)"
end
rm bun.lockb

# Test 4: Defaults to npm when no lockfile
echo -n "Test 4 - Defaults to npm (no lockfile): "
set -l result (__runner_detect_runner)
if test "$result" = npm
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: npm, got: $result)"
end

# Test 5: pnpm takes priority over others
echo -n "Test 5 - pnpm priority (pnpm over yarn): "
touch pnpm-lock.yaml yarn.lock
set -l result (__runner_detect_runner)
if test "$result" = pnpm
    echo "✓ PASS (got: $result)"
else
    echo "✗ FAIL (expected: pnpm, got: $result)"
end
rm pnpm-lock.yaml yarn.lock

# Cleanup
cd -
rm -rf $test_dir

echo ""
echo "All tests passed! ✓"
