# SYNC.md — ECC → OpenCode Sync

## Rule: One-way sync only

We **pull** from upstream and **convert**. We **never** PR back.

```
upstream (ECC) → fetch → convert → this repo → install
```

No upstream contributions from this repo. No merge conflicts. No bidirectional sync.

## Source

**Upstream:** https://github.com/affaan-m/everything-claude-code  
**Target:** https://github.com/DoozieSoftware/everything-opencode  
**Format:** OpenCode-native (markdown agents with YAML frontmatter)

## Flow

```
ECC publishes new content
        ↓
  git fetch upstream
        ↓
  diff what changed (agents, commands, skills, plugins)
        ↓
  convert to OpenCode format
        ↓
  commit + push to our repo
        ↓
  ./install.sh --target global (or per-project)
        ↓
  OpenCode picks up new agents/commands/skills
```

## What gets synced

| ECC source | OpenCode target | Conversion |
|------------|----------------|------------|
| `.opencode/prompts/agents/*.txt` | `.opencode/agents/*.md` | Add YAML frontmatter (description, mode, tools) |
| `.opencode/commands/*.md` | `.opencode/commands/*.md` | Add frontmatter if missing |
| `skills/*/SKILL.md` | `.opencode/skills/*/SKILL.md` | Copy as-is (name/description already in frontmatter) |
| `.opencode/plugins/*` | `.opencode/plugins/*` | Copy as-is |
| `.opencode/tools/*` | `.opencode/tools/*` | Copy as-is |
| `rules/common/*.md` | `AGENTS.md` | Merge into single file |
| `.opencode/opencode.json` (commands) | `opencode.json` | Merge commands, remove agent block (auto-discovered) |

## What does NOT get synced

| Item | Reason |
|------|--------|
| `.claude/` | Claude Code-specific |
| `.claude-plugin/` | Claude Code-specific |
| `.codex/` | OpenAI Codex-specific |
| `.codex-plugin/` | OpenAI Codex-specific |
| `.cursor/` | Cursor-specific |
| `.kiro/` | Kiro-specific |
| `.trae/` | Trae-specific |
| `.agents/` | ECC multi-agent format |

These directories are **deleted** during sync. They contain IDE-specific hooks, rules, and configs that have no equivalent in OpenCode.

## How to sync

### Manual sync

```bash
# 1. Clone upstream
git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git /tmp/ecc-sync

# 2. Remove non-OpenCode dirs
cd /tmp/ecc-sync
rm -rf .agents .claude .claude-plugin .codex .codex-plugin .cursor .kiro .trae .mcp.json

# 3. Convert agents (txt → md with frontmatter)
mkdir -p .opencode/agents
for txt in .opencode/prompts/agents/*.txt; do
  name=$(basename "$txt" .txt)
  # ... convert with frontmatter (see convert script below)
done

# 4. Add frontmatter to commands without it
for md in .opencode/commands/*.md; do
  head -1 "$md" | grep -q "^---$" || prepend_frontmatter "$md"
done

# 5. Copy skills to .opencode/skills/ for auto-discovery
for dir in skills/*/; do
  name=$(basename "$dir")
  mkdir -p ".opencode/skills/$name"
  cp "$dir"*.md ".opencode/skills/$name/" 2>/dev/null
done

# 6. Update opencode.json (remove agent block, merge commands)
# 7. Commit + push
```

### Automated sync

```bash
# Run the sync script (if available)
./sync-from-ecc.sh
```

## Agent frontmatter format

Each `.opencode/agents/*.md` must have:

```yaml
---
description: What this agent does
mode: subagent          # subagent | primary
tools:
  write: true           # can create files
  edit: true            # can modify files
  bash: true            # can run commands
---
<prompt content from ECC>
```

### Default tool permissions by agent

| Agent | write | edit | bash |
|-------|-------|------|------|
| `planner` | false | false | true |
| `architect` | false | false | true |
| `code-reviewer` | false | false | true |
| `go-reviewer` | false | false | true |
| `rust-reviewer` | false | false | true |
| All others | true | true | true |

## Command frontmatter format

Each `.opencode/commands/*.md` must have:

```yaml
---
description: What this command does
---
<command template>
```

## opencode.json structure

After sync, `opencode.json` should contain:

- `command` — all ECC commands with `{file:.opencode/commands/name.md}` templates
- `instructions` — path to `AGENTS.md` and other instruction files
- `plugin` — `["./plugins"]`

Agents are **not** in `opencode.json`. They are auto-discovered from `.opencode/agents/*.md`.

## Conflict resolution

**No conflicts.** This is one-way sync. On each sync:

1. Delete all OpenCode-specific files that don't exist upstream
2. Overwrite converted files with fresh upstream content
3. Re-add any OpenCode-only additions (frontmatter, README, SYNC.md)

If we add custom agents/commands/skills, they go in a separate directory or get namespaced (e.g., `doozie-custom-agent.md`) to avoid collisions with upstream.

## Version tracking

The sync does not track ECC versions. We pull `HEAD` of `main` each time. If you need to pin to a specific ECC release, note the commit hash in this file after sync.

**Last synced:** — (update after each sync)

**ECC commit:** — (update after each sync)
