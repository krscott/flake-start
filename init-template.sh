#!/usr/bin/env sh
set -eu

if [ $# -ne 1 ]; then
    echo "Usage: $(basename "$0") PROJ_NAME"
    exit 1
fi

proj="$1"

case "$proj" in
*[!A-Za-z0-9_-]* | '')
    echo "Invalid project name: $proj" >&2
    echo "Project name may only contain letters, numbers, hyphens, and underscores." >&2
    exit 1
    ;;
esac

proj_hyphen=$(printf '%s' "$proj" | tr '_' '-')

script_dir=$(CDPATH='' cd "$(dirname "$0")" && pwd -P)
cd "$script_dir"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "init-template.sh must be run from a git checkout." >&2
    exit 1
fi

git ls-files | while IFS= read -r file; do
    if [ "$file" = 'init-template.sh' ]; then
        continue
    fi

    if [ -e "$file" ]; then
        echo "Processing: $file"
        tmp="${file}.tmp.$$"
        sed "s/flake-start/$proj_hyphen/g" "$file" >"$tmp"
        mv "$tmp" "$file"
    fi
done

echo "Deleting init script"
rm -f LICENSE
rm -f .github/workflows/init-template-test.yml
rm -- "$0"
