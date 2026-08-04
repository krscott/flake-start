set positional-arguments

default:
    just --list

build:
    printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' 'printf '\''Hello from hello.sh\n'\''' > hello.sh
    chmod +x hello.sh

run: build
    ./hello.sh

# Format files, or all tracked files when no files are provided.
format *files:
    #!/usr/bin/env bash
    set -euo pipefail

    declare -a files=()

    if (($# == 0)); then
        mapfile -t files < <(git ls-files)
    else
        files=("$@")
    fi

    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            continue
        fi

        case "$file" in
            justfile|Justfile|.justfile)
                if (($# != 0)); then
                    just --fmt
                fi
            ;;
            *.sh)
                shfmt -w -i 4 "$file"
            ;;
        esac
    done

# Format staged files for git pre-commit.
pre-commit:
    #!/usr/bin/env bash
    set -euo pipefail

    declare -a staged_files
    declare -a format_files=()
    declare -A partially_staged
    file=''

    mapfile -d '' -t staged_files < <(
        git diff --cached --name-only --diff-filter=ACMR -z
    )

    while IFS= read -r -d '' file; do
        partially_staged["$file"]=1
    done < <(git diff --name-only -z)

    for file in "${staged_files[@]}"; do
        if [[ -v partially_staged["$file"] ]]; then
            continue
        fi

        format_files+=("$file")
    done

    if ((${#format_files[@]} == 0)); then
        exit 0
    fi

    just format "${format_files[@]}"
    git add -- "${format_files[@]}"

# Install a pre-commit hook that formats git-changed files.
install-hooks:
    git config core.hooksPath .githooks
