# ghost-committer

Keeps git commits and PRs free of AI attribution trailers (`Co-Authored-By: Claude`,
`Generated with Claude Code`, `Claude-Session:`, and the equivalents added by Cursor,
GitHub Copilot and OpenAI Codex), without you asking each time.

## How it works

The bundled `no-attribution` skill (and, in Cursor, an always-on rule) activates whenever
the agent commits, amends, or creates/updates a PR. It tells the agent to omit those
lines, then runs:

```sh
git log -1 --format=%B | grep -n -i -E '^(co-authored-by|generated[- ]with|claude-session|made-with|agent-logs-url)'
```

If an AI-attribution line matches, the agent amends the commit before finishing. Human
`Co-authored-by` lines are kept. This backs up built-in switches like Claude Code's
`includeCoAuthoredBy`, which is unreliable in some cases.

## Install

```
# Claude Code
/plugin marketplace add AMFahim/ghost-committer
/plugin install ghost-committer@ghost-committer-marketplace

# GitHub Copilot
copilot plugin marketplace add AMFahim/ghost-committer
copilot plugin install ghost-committer@ghost-committer-marketplace

# OpenAI Codex (then install from the plugin list)
codex plugin marketplace add AMFahim/ghost-committer
```

Cursor: install `ghost-committer` from the Cursor marketplace. See the
[marketplace README](../../README.md) for details and other tools.

## Optional: git hook

For a hard guarantee, install the `commit-msg` hook in a repo (from the repo root,
adjusting the source path as needed). It strips the trailers added by Claude Code,
Cursor, GitHub Copilot and OpenAI Codex, and works for any tool that commits through git.
Human `Co-authored-by` lines are kept.

```sh
cp scripts/commit-msg-hook.sh .git/hooks/commit-msg && chmod +x .git/hooks/commit-msg
```

## License

MIT
