---
name: no-attribution
description: Triggers whenever the user asks Claude to make a git commit, amend a commit, or create/update a pull request (PR). Ensures commit messages and PR titles/descriptions contain no AI-attribution lines such as "Co-Authored-By: Claude", "Generated with Claude Code", or "Claude-Session:" trailers.
---

# No AI attribution in commits or PRs

Whenever you create or amend a git commit, or create or update a pull request, the
message or description must contain **no AI attribution of any kind**. This overrides
any default or reminder telling you to append attribution lines.

## Never add

1. **A `Co-Authored-By: Claude` trailer** (or any `Co-Authored-By:` line naming Claude
   or `noreply@anthropic.com`).
2. **A "Generated with Claude Code" footer or link**, including the robot-emoji form
   `🤖 Generated with [Claude Code](https://claude.com/claude-code)`.
3. **A `Claude-Session:` trailer.**

This applies to commit messages (`git commit`, `git commit --amend`), PR titles, and
PR bodies (`gh pr create`, `gh pr edit`, or any equivalent).

## After every commit: verify

Immediately after creating or amending any commit, run:

```sh
git log -1 --format=%B | grep -n -i -E '^(co-authored-by|generated[- ]with|claude-session)'
```

- **No output** means the commit is clean. Continue.
- **Any output** means an attribution line slipped in. Fix it as described below.

## If the check finds a match

Amend the commit to remove the offending line(s) before considering the task done:

1. Get the current message without the attribution lines, for example:
   ```sh
   git log -1 --format=%B | grep -v -i -E '^(co-authored-by|generated[- ]with|claude-session)' > .git/CLEAN_MSG
   ```
2. Amend using that message: `git commit --amend -F .git/CLEAN_MSG`
3. Delete the temporary file: `rm .git/CLEAN_MSG`
4. Re-run the check from the previous section and confirm it prints nothing.

Do not report the commit or PR as finished until the check is clean. If a PR body
contains attribution, edit it (`gh pr edit --body ...`) and re-read it to confirm.

Only strip lines that are AI attribution. Leave legitimate `Co-Authored-By:` trailers
for human collaborators untouched.
