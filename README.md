# ghost-committer-marketplace

A plugin marketplace for **ghost-committer**, which keeps your git commits and pull
requests free of AI attribution. It works with Claude Code, OpenAI Codex, GitHub Copilot
and Cursor, and the bundled git hook works with any tool that commits through git.

## What it does

AI coding tools can add lines like these to commits and PRs:

- `Co-Authored-By: Claude <noreply@anthropic.com>`
- `🤖 Generated with [Claude Code](https://claude.com/claude-code)`
- `Claude-Session: ...`
- `Co-authored-by: Cursor <cursoragent@cursor.com>` / `Made-with: Cursor`
- `Co-authored-by: Copilot <...@users.noreply.github.com>` / `Agent-Logs-Url: ...`
- `Co-authored-by: Codex <noreply@openai.com>`

**ghost-committer** makes sure none of them end up in your history, without you having
to ask each time. It ships a `no-attribution` skill (plus an always-on rule for Cursor)
that activates whenever the agent is asked to commit, amend, or create/update a PR. It
tells the agent to leave those lines out, then verify the result and amend the commit if
anything slipped through.

## Why

Built-in switches, such as Claude Code's `includeCoAuthoredBy` setting, are unreliable in
some cases: attribution can still appear in certain flows, such as PR descriptions and
other trailers. ghost-committer adds a behavioral guard and a verification step on top,
so the outcome doesn't depend on one setting.

## Install

### Claude Code

```
/plugin marketplace add AMFahim/ghost-committer
/plugin install ghost-committer@ghost-committer-marketplace
```

### GitHub Copilot (CLI, VS Code)

```
copilot plugin marketplace add AMFahim/ghost-committer
copilot plugin install ghost-committer@ghost-committer-marketplace
```

### OpenAI Codex

```
codex plugin marketplace add AMFahim/ghost-committer
```

Then install `ghost-committer` from Codex's plugin list.

### Cursor

Cursor installs plugins from its marketplace or from a team admin's dashboard. Once this
repo is listed at [cursor.com/marketplace](https://cursor.com/marketplace), install
`ghost-committer` from there. Its always-on rule (`rules/no-attribution.mdc`) applies to
every chat.

### Any other tool

Copy `plugins/ghost-committer/skills/no-attribution/SKILL.md` into the tool's skills
folder, or paste the text of `plugins/ghost-committer/rules/no-attribution.mdc` into your
`AGENTS.md` (or equivalent instructions file).

## Optional: git hook for an extra guarantee

Skills and rules rely on the agent following instructions. For a hard guarantee, install
the bundled `commit-msg` hook, which strips attribution lines from every commit message
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
works whichever tool makes the commit, unless a tool bypasses hooks with `--no-verify`.
It only edits commit messages, not PR titles or descriptions.

## Layout

One repo carries a marketplace file for each tool; all of them point at the same plugin.

```
.claude-plugin/marketplace.json      Claude Code
.agents/plugins/marketplace.json     OpenAI Codex
.github/plugin/marketplace.json      GitHub Copilot
.cursor-plugin/marketplace.json      Cursor
plugins/ghost-committer/
  .claude-plugin/plugin.json         Claude Code manifest
  .codex-plugin/plugin.json          Codex manifest
  plugin.json                        Copilot (Agent Plugins) manifest
  .cursor-plugin/plugin.json         Cursor manifest
  skills/no-attribution/SKILL.md     shared skill
  rules/no-attribution.mdc           Cursor always-on rule
  scripts/commit-msg-hook.sh         optional git hook
```

## Compatibility

The Claude Code install is tested. The Codex, Copilot and Cursor manifests follow each
tool's published plugin format but have not been tested in those tools yet. Please open an
issue if one doesn't install.

## License

MIT
