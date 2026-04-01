# Everything OpenCode

OpenCode-native fork of [everything-claude-code](https://github.com/affaan-m/everything-claude-code) — the agent harness performance optimization system.

**14 agents** · **34 commands** · **137 skills** · **OpenCode-native format**

## Install

### Option 1: Global install (recommended)

Install once, use in every project.

```bash
git clone --depth 1 https://github.com/DoozieSoftware/everything-opencode.git /tmp/ecc

# Copy agents, commands, skills, plugins, tools
cp -r /tmp/ecc/.opencode/agents/*   ~/.config/opencode/agents/
cp -r /tmp/ecc/.opencode/commands/* ~/.config/opencode/commands/
cp -r /tmp/ecc/.opencode/skills/*   ~/.config/opencode/skills/
cp -r /tmp/ecc/.opencode/plugins/*  ~/.config/opencode/plugins/ 2>/dev/null
cp -r /tmp/ecc/.opencode/tools/*    ~/.config/opencode/tools/ 2>/dev/null
cp /tmp/ecc/AGENTS.md               ~/.config/opencode/

# Merge commands + instructions into global opencode.json
# (preserves your existing providers/models)
cat ~/.config/opencode/opencode.json | jq \
  --argjson commands "$(cat /tmp/ecc/.opencode/opencode.json | jq '.command')" \
  --argjson instructions "$(cat /tmp/ecc/.opencode/opencode.json | jq '.instructions')" \
  '.command = ((.command // {}) + $commands) |
   .instructions = ((.instructions // []) + $instructions | unique)' \
  > /tmp/ecc-merged.json && mv /tmp/ecc-merged.json ~/.config/opencode/opencode.json

rm -rf /tmp/ecc
```

Then run `opencode` in any project. Everything is available globally.

### Option 2: Per-project install

```bash
git clone https://github.com/DoozieSoftware/everything-opencode.git /tmp/ecc
cp -r /tmp/ecc/.opencode /path/to/your/project/
cp /tmp/ecc/AGENTS.md /path/to/your/project/
opencode
```

### Option 3: Clone and run

```bash
git clone https://github.com/DoozieSoftware/everything-opencode.git
cd everything-opencode
opencode
```

## What's included

### Agents (`~/.config/opencode/agents/`)

| Agent | Description |
|-------|-------------|
| `planner` | Implementation planning |
| `architect` | System design |
| `code-reviewer` | Code quality review |
| `security-reviewer` | Security vulnerability detection |
| `tdd-guide` | Test-driven development |
| `build-error-resolver` | Build/TS error fixes |
| `e2e-runner` | Playwright E2E testing |
| `doc-updater` | Documentation sync |
| `refactor-cleaner` | Dead code cleanup |
| `go-reviewer` | Go code review |
| `go-build-resolver` | Go build errors |
| `database-reviewer` | PostgreSQL optimization |
| `rust-reviewer` | Rust code review |
| `rust-build-resolver` | Rust/Cargo errors |

### Commands

`/plan` `/tdd` `/code-review` `/security` `/build-fix` `/e2e` `/refactor-clean` `/orchestrate` `/learn` `/verify` `/eval` `/go-review` `/go-build` `/rust-review` `/rust-build` `/harness-audit` `/loop-start` `/quality-gate` `/model-route` and more.

### Skills

Auto-discovered from `~/.config/opencode/skills/*/SKILL.md`. 137 skills covering TDD, security, patterns, testing, API design, and more.

## Usage

```bash
opencode              # Start OpenCode (any project)
/plan "Add auth"      # Use ECC planner
/code-review          # Review code
/security             # Security scan
/tdd                  # TDD workflow
@code-reviewer        # Invoke subagent directly
Tab                   # Switch between build/plan agents
```

## Architecture

OpenCode discovers components automatically:

| Location | What |
|----------|------|
| `~/.config/opencode/agents/*.md` | Agents (YAML frontmatter + prompt) |
| `~/.config/opencode/commands/*.md` | Commands (YAML frontmatter + template) |
| `~/.config/opencode/skills/*/SKILL.md` | Skills (auto-discovered) |
| `~/.config/opencode/plugins/*` | Plugins (JS/TS hooks) |
| `~/.config/opencode/tools/*` | Custom tools |
| `~/.config/opencode/AGENTS.md` | Global instructions/rules |
| `~/.config/opencode/opencode.json` | Config |

## Sync from upstream

This repo is a one-way sync from [everything-claude-code](https://github.com/affaan-m/everything-claude-code). See [SYNC.md](SYNC.md) for details.

## Original

Forked from [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code). Adapted for OpenCode's native format — removed Claude Code, Codex, Cursor, Kiro, and Trae specific configs.

## License

MIT
