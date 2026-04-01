# Everything OpenCode

OpenCode-native fork of [everything-claude-code](https://github.com/affaan-m/everything-claude-code) — the agent harness performance optimization system.

**14 agents** · **30+ commands** · **130+ skills** · **OpenCode-native format**

## Install

### Option 1: Clone and run

```bash
git clone https://github.com/DoozieSoftware/everything-opencode.git
cd everything-opencode
opencode
```

### Option 2: Copy into your project

```bash
git clone https://github.com/DoozieSoftware/everything-opencode.git /tmp/ecc
cp -r /tmp/ecc/.opencode /path/to/your/project/
cp /tmp/ecc/AGENTS.md /path/to/your/project/
cp -r /tmp/ecc/skills /path/to/your/project/
opencode  # run from your project
```

## What's included

### Agents (`.opencode/agents/`)

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

### Commands (`.opencode/commands/`)

`/plan` `/tdd` `/code-review` `/security` `/build-fix` `/e2e` `/refactor-clean` `/orchestrate` `/learn` `/verify` `/eval` `/go-review` `/go-build` `/rust-review` `/rust-build` `/harness-audit` `/loop-start` `/quality-gate` `/model-route` and more.

### Skills (`.opencode/skills/`)

Auto-discovered from `.opencode/skills/*/SKILL.md`. 130+ skills covering TDD, security, patterns, testing, API design, and more.

### Plugins (`.opencode/plugins/`)

Loaded via `opencode.json` -> `plugin` key.

## Usage

```bash
opencode              # Start OpenCode
/plan "Add auth"      # Use ECC planner
/code-review          # Review code
@code-reviewer        # Invoke subagent directly
Tab                   # Switch between primary agents
```

## Architecture

OpenCode discovers components automatically:

| Location | What |
|----------|------|
| `.opencode/agents/*.md` | Agents (YAML frontmatter + prompt) |
| `.opencode/commands/*.md` | Commands (YAML frontmatter + template) |
| `.opencode/skills/*/SKILL.md` | Skills (auto-discovered) |
| `.opencode/plugins/*` | Plugins (JS/TS hooks) |
| `.opencode/tools/*` | Custom tools |
| `AGENTS.md` | Global instructions/rules |
| `opencode.json` | Config |

## Original

Forked from [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code). Adapted for OpenCode's native format — removed Claude Code, Codex, Cursor, Kiro, and Trae specific configs.

## License

MIT
