# ghost-committer-marketplace

A Claude Code plugin marketplace hosting **ghost-committer**, a plugin that keeps your
git commits and pull requests free of AI attribution.

## What it does

By default, Claude Code can add lines like these to commits and PRs:

- `Co-Authored-By: Claude <noreply@anthropic.com>`
- `🤖 Generated with [Claude Code](https://claude.com/claude-code)`
- `Claude-Session: ...`

**ghost-committer** makes sure none of them end up in your history, without you having
to ask each time. It ships a `no-attribution` skill that activates whenever Claude is
asked to commit, amend, or create/update a PR. The skill tells Claude to leave those
lines out, then verify the result and amend the commit if anything slipped through.

## Why

Claude Code has a built-in `includeCoAuthoredBy` setting, but it is unreliable in some
cases: attribution can still appear in certain flows, such as PR descriptions and other
trailers. ghost-committer adds a behavioral guard and a verification step on top, so the
outcome doesn't depend on that one setting.

## Install

```
/plugin marketplace add AMFahim/ghost-committer
/plugin install ghost-committer@ghost-committer-marketplace
```

## Optional: git hook for an extra guarantee

The skill relies on Claude following instructions. For a hard guarantee, install the
bundled `commit-msg` hook, which strips attribution lines from every commit message
in a repository, whoever (or whatever) makes the commit:

```sh
cp scripts/commit-msg-hook.sh .git/hooks/commit-msg && chmod +x .git/hooks/commit-msg
```

Run this from the repo root, and adjust the source path to the script's location
(in this marketplace: `plugins/ghost-committer/scripts/commit-msg-hook.sh`). The hook
is POSIX `sh` and removes these AI-attribution lines (case-insensitive):

| Tool | Lines removed |
|---|---|
| Claude Code | `Co-Authored-By: Claude ...`, `Generated with [Claude Code]`, `Claude-Session:` |
| Cursor | `Co-authored-by: Cursor <cursoragent@cursor.com>`, `Made-with: Cursor` |
| GitHub Copilot | `Co-authored-by: Copilot <...@users.noreply.github.com>`, `Agent-Logs-Url:` |
| OpenAI Codex | `Co-authored-by: Codex <noreply@openai.com>` |

Co-authored-by lines for real people are left alone. Because it is a plain git hook, it
also works when those other tools make the commit, unless they bypass hooks with
`--no-verify`. It only edits commit messages, not PR titles or descriptions.

## Layout

```
.claude-plugin/marketplace.json
plugins/ghost-committer/
  .claude-plugin/plugin.json
  skills/no-attribution/SKILL.md
  scripts/commit-msg-hook.sh
```

## License

MIT
