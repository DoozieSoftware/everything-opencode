---
name: add-or-update-skill-documentation
description: Workflow command scaffold for add-or-update-skill-documentation in everything-claude-code.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /add-or-update-skill-documentation

Use this workflow when working on **add-or-update-skill-documentation** in `everything-claude-code`.

## Goal

Adds a new skill or updates documentation for an existing skill, typically in the form of a SKILL.md file under skills/ or skills/*/SKILL.md, sometimes with translations in docs/xx/skills/*/SKILL.md.

## Common Files

- `skills/*/SKILL.md`
- `docs/zh-CN/skills/*/SKILL.md`
- `docs/tr/skills/*/SKILL.md`
- `docs/pt-BR/skills/*/SKILL.md`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Create or update skills/<skill-name>/SKILL.md
- Optionally update docs/xx/skills/<skill-name>/SKILL.md for translations
- Commit with a message referencing the skill and a summary of changes

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.