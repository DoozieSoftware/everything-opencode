---
name: everything-claude-code-conventions
description: Development conventions and patterns for everything-claude-code. JavaScript project with conventional commits.
---

# Everything Claude Code Conventions

> Generated from [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) on 2026-03-24

## Overview

This skill teaches Claude the development patterns and conventions used in everything-claude-code.

## Tech Stack

- **Primary Language**: JavaScript
- **Architecture**: hybrid module organization
- **Test Location**: separate

## When to Use This Skill

Activate this skill when:
- Making changes to this repository
- Adding new features following established patterns
- Writing tests that match project conventions
- Creating commits with proper message format

## Commit Conventions

Follow these commit message conventions based on 500 analyzed commits.

### Commit Style: Conventional Commits

### Prefixes Used

- `fix`
- `feat`
- `docs`
- `test`

### Message Guidelines

- Average message length: ~62 characters
- Keep first line concise and descriptive
- Use imperative mood ("Add feature" not "Added feature")


*Commit message example*

```text
feat(ecc2): add tool call logging and history
```

*Commit message example*

```text
perf(hooks): move post-edit-format and post-edit-typecheck to strict-only (#757)
```

*Commit message example*

```text
fix: safe Codex config sync — merge AGENTS.md + add-only MCP servers (#723)
```

*Commit message example*

```text
docs(zh-CN): translate code block(plain text) (#753)
```

*Commit message example*

```text
security: remove supply chain risks, external promotions, and unauthorized credits
```

*Commit message example*

```text
feat: scaffold ECC 2.0 Rust TUI — agentic IDE control plane
```

*Commit message example*

```text
feat(skills): add santa-method - multi-agent adversarial verification (#760)
```

*Commit message example*

```text
feat: pending instinct TTL pruning and /prune command (#725)
```

## Architecture

### Project Structure: Single Package

This project uses **hybrid** module organization.

### Configuration Files

- `.github/workflows/ci.yml`
- `.github/workflows/maintenance.yml`
- `.github/workflows/monthly-metrics.yml`
- `.github/workflows/release.yml`
- `.github/workflows/reusable-release.yml`
- `.github/workflows/reusable-test.yml`
- `.github/workflows/reusable-validate.yml`
- `.opencode/package.json`
- `.opencode/tsconfig.json`
- `.prettierrc`
- `eslint.config.js`
- `package.json`

### Guidelines

- This project uses a hybrid organization
- Follow existing patterns when adding new code

## Code Style

### Language: JavaScript

### Naming Conventions

| Element | Convention |
|---------|------------|
| Files | camelCase |
| Functions | camelCase |
| Classes | PascalCase |
| Constants | SCREAMING_SNAKE_CASE |

### Import Style: Relative Imports

### Export Style: Mixed Style


*Preferred import style*

```typescript
// Use relative imports
import { Button } from '../components/Button'
import { useAuth } from './hooks/useAuth'
```

## Testing

### Test Framework

No specific test framework detected — use the repository's existing test patterns.

### File Pattern: `*.test.js`

### Test Types

- **Unit tests**: Test individual functions and components in isolation
- **Integration tests**: Test interactions between multiple components/services

### Coverage

This project has coverage reporting configured. Aim for 80%+ coverage.


## Error Handling

### Error Handling Style: Try-Catch Blocks


*Standard error handling pattern*

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('User-friendly message')
}
```

## Common Workflows

These workflows were detected from analyzing commit patterns.

### Database Migration

Database schema changes with migration files

**Frequency**: ~2 times per month

**Steps**:
1. Create migration file
2. Update schema definitions
3. Generate/update types

**Files typically involved**:
- `migrations/*`

**Example commit sequence**:
```
feat(rules): add C# language support (#704)
fix: sanitize SessionStart session summaries (#710)
feat: add MCP health-check hook (#711)
```

### Feature Development

Standard feature implementation workflow

**Frequency**: ~16 times per month

**Steps**:
1. Add feature implementation
2. Add tests for feature
3. Update documentation

**Files typically involved**:
- `manifests/*`
- `**/*.test.*`
- `**/api/**`

**Example commit sequence**:
```
feat: agent description compression with lazy loading (#696)
feat: add nuxt 4 patterns skill (#702)
feat(rules): add C# language support (#704)
```

### Add Or Update Skill Documentation

Adds a new skill or updates existing skill documentation, typically in SKILL.md under skills/<skill-name>/ or docs/<lang>/skills/<skill-name>/SKILL.md.

**Frequency**: ~4 times per month

**Steps**:
1. Create or update SKILL.md in the appropriate skills/<skill-name>/ directory.
2. Optionally update language-localized documentation under docs/<lang>/skills/<skill-name>/SKILL.md.
3. Commit with a message referencing the skill and summary of the change.

**Files typically involved**:
- `skills/*/SKILL.md`
- `docs/*/skills/*/SKILL.md`

**Example commit sequence**:
```
Create or update SKILL.md in the appropriate skills/<skill-name>/ directory.
Optionally update language-localized documentation under docs/<lang>/skills/<skill-name>/SKILL.md.
Commit with a message referencing the skill and summary of the change.
```

### Add Or Update Multilingual Documentation

Adds or updates documentation in a new or existing language, involving many files under docs/<lang>/.

**Frequency**: ~2 times per month

**Steps**:
1. Add or update multiple files under docs/<lang>/ (agents, commands, skills, rules, etc).
2. Update README.md to reference the new or updated language.
3. Commit with a message referencing the language and type of update.

**Files typically involved**:
- `docs/*/*`
- `README.md`

**Example commit sequence**:
```
Add or update multiple files under docs/<lang>/ (agents, commands, skills, rules, etc).
Update README.md to reference the new or updated language.
Commit with a message referencing the language and type of update.
```

### Add Or Update Hook Or Script

Adds a new hook or updates an existing one, often for validation, protection, or automation, involving hooks.json and scripts/hooks/.

**Frequency**: ~2 times per month

**Steps**:
1. Create or update a script in scripts/hooks/ (e.g., config-protection.js, mcp-health-check.js).
2. Update hooks/hooks.json to register or modify the hook.
3. Optionally add or update tests in tests/hooks/.
4. Commit with a message referencing the hook and its purpose.

**Files typically involved**:
- `scripts/hooks/*.js`
- `hooks/hooks.json`
- `tests/hooks/*.test.js`

**Example commit sequence**:
```
Create or update a script in scripts/hooks/ (e.g., config-protection.js, mcp-health-check.js).
Update hooks/hooks.json to register or modify the hook.
Optionally add or update tests in tests/hooks/.
Commit with a message referencing the hook and its purpose.
```

### Feature Implementation With Tests And Docs

Implements a new feature or enhancement, updates implementation files, adds or updates tests, and updates documentation.

**Frequency**: ~3 times per month

**Steps**:
1. Implement the feature in source files (e.g., scripts/lib/, src/, etc).
2. Add or update corresponding test files (e.g., tests/lib/, tests/hooks/).
3. Update or add documentation (e.g., README.md, AGENTS.md, docs/).
4. Commit all related changes together.

**Files typically involved**:
- `scripts/lib/*.js`
- `src/**/*.rs`
- `tests/**/*.test.js`
- `README.md`
- `AGENTS.md`
- `docs/**/*`

**Example commit sequence**:
```
Implement the feature in source files (e.g., scripts/lib/, src/, etc).
Add or update corresponding test files (e.g., tests/lib/, tests/hooks/).
Update or add documentation (e.g., README.md, AGENTS.md, docs/).
Commit all related changes together.
```

### Add Or Update Language Support

Adds support for a new programming language or updates language-specific rules, patterns, or testing guides.

**Frequency**: ~2 times per month

**Steps**:
1. Add or update files under rules/<language>/ (coding-style.md, hooks.md, patterns.md, security.md, testing.md).
2. Optionally update install-manifests or language alias maps.
3. Commit with a message referencing the language and the nature of the support.

**Files typically involved**:
- `rules/*/*.md`
- `scripts/lib/install-manifests.js`
- `manifests/install-components.json`
- `tests/lib/install-manifests.test.js`

**Example commit sequence**:
```
Add or update files under rules/<language>/ (coding-style.md, hooks.md, patterns.md, security.md, testing.md).
Optionally update install-manifests or language alias maps.
Commit with a message referencing the language and the nature of the support.
```

### Codex Sync Or Merge Automation

Automates synchronization or merging of configuration files between ECC and Codex, often using marker-based merging and Node scripts.

**Frequency**: ~2 times per month

**Steps**:
1. Update or create scripts in scripts/codex/ or scripts/sync-ecc-to-codex.sh.
2. Update AGENTS.md or config files in .codex/.
3. Update README.md to reflect changes in sync logic or server lists.
4. Commit with a message referencing sync, merge, or Codex.

**Files typically involved**:
- `scripts/codex/*.js`
- `scripts/sync-ecc-to-codex.sh`
- `.codex/AGENTS.md`
- `README.md`

**Example commit sequence**:
```
Update or create scripts in scripts/codex/ or scripts/sync-ecc-to-codex.sh.
Update AGENTS.md or config files in .codex/.
Update README.md to reflect changes in sync logic or server lists.
Commit with a message referencing sync, merge, or Codex.
```


## Best Practices

Based on analysis of the codebase, follow these practices:

### Do

- Use conventional commit format (feat:, fix:, etc.)
- Follow *.test.js naming pattern
- Use camelCase for file names
- Prefer mixed exports

### Don't

- Don't write vague commit messages
- Don't skip tests for new features
- Don't deviate from established patterns without discussion

---

*This skill was auto-generated by [ECC Tools](https://ecc.tools). Review and customize as needed for your team.*
