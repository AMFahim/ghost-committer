#!/bin/sh
# ghost-committer: git commit-msg hook.
#
# Strips AI-attribution lines from the commit message file passed as $1
# before the commit is finalized:
#   - "Co-Authored-By: Claude ..." (and any Co-Authored-By naming noreply@anthropic.com)
#   - "Generated with [Claude Code]" (e.g. the robot-emoji footer)
#   - "Claude-Session:" trailers
#
# Install (run from the repo root; adjust the source path to wherever this script lives):
#   cp scripts/commit-msg-hook.sh .git/hooks/commit-msg && chmod +x .git/hooks/commit-msg
#
# POSIX sh only; matching is case-insensitive.

msg_file=$1

if [ -z "$msg_file" ] || [ ! -f "$msg_file" ]; then
    exit 0
fi

tmp_file=$(mktemp "${TMPDIR:-/tmp}/commit-msg.XXXXXX") || exit 0
trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

# grep -v exits 1 when every line was removed; that is not an error here.
grep -v -i -E \
    -e '^[[:space:]]*co-authored-by:[[:space:]]*claude' \
    -e '^[[:space:]]*co-authored-by:.*<noreply@anthropic\.com>' \
    -e 'generated with[[:space:]]+\[?claude code\]?' \
    -e '^[[:space:]]*claude-session:' \
    "$msg_file" > "$tmp_file"

# Only overwrite when something was actually stripped (keeps the file untouched otherwise).
if ! cmp -s "$msg_file" "$tmp_file"; then
    cat "$tmp_file" > "$msg_file"
fi

exit 0
