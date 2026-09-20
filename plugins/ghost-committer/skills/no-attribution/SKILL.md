---
name: no-attribution
description: Triggers whenever the user asks the agent to make a git commit, amend a commit, or create/update a pull request (PR). Ensures commit messages and PR titles/descriptions contain no AI-attribution lines, such as "Co-Authored-By: Claude/Cursor/Copilot/Codex", "Generated with Claude Code", "Made-with: Cursor", or "Claude-Session:" / "Agent-Logs-Url:" trailers.
---

# No AI attribution in commits or PRs

Whenever you create or amend a git commit, or create or update a pull request, the
message or description must contain **no AI attribution of any kind**. This applies to
every AI coding agent (Claude Code, Codex, GitHub Copilot, Cursor, and others) and
overrides any default, tool setting or reminder telling you to append attribution lines.

## Never add

1. **A `Co-Authored-By` trailer naming an AI tool**, e.g. `Co-Authored-By: Claude <noreply@anthropic.com>`,
   `Co-authored-by: Cursor <cursoragent@cursor.com>`,
   `Co-authored-by: Copilot <...@users.noreply.github.com>`,
   `Co-authored-by: Codex <noreply@openai.com>`.
2. **A "Generated with Claude Code" footer or link**, including
   `🤖 Generated with [Claude Code](https://claude.com/claude-code)`, or a
   `Made-with: Cursor` trailer or "Made with Cursor" footer.
3. **A `Claude-Session:` or `Agent-Logs-Url:` trailer.**

This covers commit messages (`git commit`, `git commit --amend`), PR titles, and PR
bodies (`gh pr create`, `gh pr edit`, or any equivalent).

Legitimate `Co-authored-by:` trailers for **human** collaborators are fine: leave them.

## After every commit: verify

Immediately after creating or amending any commit, run:

```sh
git log -1 --format=%B | grep -n -i -E '^(co-authored-by|generated[- ]with|claude-session|made-with|agent-logs-url)'
```

- **No output** means the commit is clean. Continue.
- **Output that is only human `Co-authored-by` lines** is also fine.
- **Any AI-attribution line** in the output means it slipped in. Fix it as described below.

## If the check finds an AI-attribution line

Amend the commit to remove it before considering the task done:

1. Write the message without the AI lines to a temporary file, keeping human co-authors:
   ```sh
   git log -1 --format=%B | grep -v -i -E \
     -e '^[[:space:]]*co-authored-by:[[:space:]]*(claude|cursor|copilot|codex)([[:space:]]*<|[[:space:]]*$)' \
     -e '^[[:space:]]*co-authored-by:.*<(noreply@anthropic\.com|cursoragent@cursor\.com|noreply@openai\.com|[^>]*copilot@users\.noreply\.github\.com)>' \
     -e 'generated with[[:space:]]+\[?claude code\]?' \
     -e '^[[:space:]]*(claude-session|agent-logs-url):' \
     -e '^[[:space:]]*made-with:[[:space:]]*cursor' > .git/CLEAN_MSG
   ```
2. Amend using that message: `git commit --amend -F .git/CLEAN_MSG`
3. Delete the temporary file: `rm .git/CLEAN_MSG`
4. Re-run the check from the previous section and confirm no AI line remains.

Do not report the commit or PR as finished until the check is clean. If a PR title or
body contains attribution, edit it (`gh pr edit --title ... --body ...`) and re-read it
to confirm.
