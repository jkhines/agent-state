#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"

    # No-op when destination already points to the intended source.
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "OK: $dest already -> $src"
        return 0
    fi

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        # Create a single backup copy and avoid cascading backups on reruns.
        if [ ! -e "${dest}.bak" ]; then
            echo "Backing up existing $dest to ${dest}.bak"
            mv "$dest" "${dest}.bak"
        else
            echo "WARN: $dest exists and ${dest}.bak already exists; skipping."
            return 0
        fi
    fi
    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
}

# Remove symlinks previously installed from this repository (including stale names/layouts).
cleanup_repo_symlinks() {
    local dir="$1"
    local entry target

    [ -d "$dir" ] || return 0

    for entry in "$dir"/*; do
        [ -e "$entry" ] || [ -L "$entry" ] || continue
        [ -L "$entry" ] || continue

        target="$(readlink "$entry")"
        case "$target" in
            "$REPO_DIR"/*)
                rm "$entry"
                echo "Removed stale link: $entry"
                ;;
        esac
    done
}

chmod +x "$REPO_DIR/.githooks/pre-commit" "$REPO_DIR/install.sh" "$REPO_DIR/setup.sh"

# Ensure repository hooks are active for this clone.
if git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$REPO_DIR" config core.hooksPath .githooks
    echo "Configured git hooks path: .githooks"
fi

# ~/.claude/skills
mkdir -p "$HOME/.claude/skills"
cleanup_repo_symlinks "$HOME/.claude/skills"
for skill_dir in "$REPO_DIR/skills/"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    link "$skill_dir" "$HOME/.claude/skills/$skill_name"
done

# ~/.cursor/skills
mkdir -p "$HOME/.cursor/skills"
cleanup_repo_symlinks "$HOME/.cursor/skills"
for skill_dir in "$REPO_DIR/skills/"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    link "$skill_dir" "$HOME/.cursor/skills/$skill_name"
done

echo "Done."
