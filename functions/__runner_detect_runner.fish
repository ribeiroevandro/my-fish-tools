function __runner_detect_runner --description "Detect package manager from lockfile"
    if test -f pnpm-lock.yaml
        echo pnpm
    else if test -f yarn.lock
        echo yarn
    else if test -f bun.lockb
        echo bun
    else
        echo npm
    end
end
