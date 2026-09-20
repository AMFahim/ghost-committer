# ghost-committer

Keeps git commits and PRs free of AI attribution trailers (`Co-Authored-By: Claude`,
`Generated with Claude Code`, `Claude-Session:`), without you asking each time.

## How it works

The bundled `no-attribution` skill activates whenever Claude commits, amends, or
creates/updates a PR. It tells Claude to omit those lines, then runs:

```sh
git log -1 --format=%B | grep -n -i -E '^(co-authored-by|generated[- ]with|claude-session)'
```

If anything matches, Claude amends the commit before finishing. This backs up Claude
Code's built-in `includeCoAuthoredBy` setting, which is unreliable in some cases.

## Install

```
/plugin marketplace add AMFahim/ghost-committer
/plugin install ghost-committer@ghost-committer-marketplace
```

## Optional: git hook

For a hard guarantee, install the `commit-msg` hook in a repo (from the repo root,
adjusting the source path as needed):

```sh
cp scripts/commit-msg-hook.sh .git/hooks/commit-msg && chmod +x .git/hooks/commit-msg
```

## License

MIT
