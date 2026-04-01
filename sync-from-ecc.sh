#!/bin/bash
# sync-from-ecc.sh — One-way sync from everything-claude-code to everything-opencode
#
# Pulls upstream ECC, converts to OpenCode format, commits.
# We NEVER PR back to upstream. One-way only.

set -e

UPSTREAM="https://github.com/affaan-m/everything-claude-code.git"
WORKDIR="/tmp/ecc-sync-$$"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== ECC → OpenCode Sync ==="
echo ""

# Clone upstream
echo "[1/7] Fetching upstream..."
git clone --depth 1 "$UPSTREAM" "$WORKDIR" 2>/dev/null

# Remove non-OpenCode dirs
echo "[2/7] Cleaning IDE-specific dirs..."
cd "$WORKDIR"
rm -rf .agents .claude .claude-plugin .codex .codex-plugin .cursor .kiro .trae .mcp.json

# Convert agents
echo "[3/7] Converting agents..."
mkdir -p .opencode/agents
for txt in .opencode/prompts/agents/*.txt; do
  [ -f "$txt" ] || continue
  name=$(basename "$txt" .txt)
  content=$(cat "$txt")

  # Defaults
  desc="ECC ${name} agent"
  write="true"
  edit="true"

  case "$name" in
    planner)         desc="Expert planning specialist"; write="false"; edit="false" ;;
    architect)       desc="Software architecture specialist"; write="false"; edit="false" ;;
    code-reviewer)   desc="Code review specialist"; write="false"; edit="false" ;;
    go-reviewer)     desc="Go code reviewer"; write="false"; edit="false" ;;
    rust-reviewer)   desc="Rust code reviewer"; write="false"; edit="false" ;;
    security-reviewer) desc="Security vulnerability detection specialist" ;;
    tdd-guide)       desc="TDD specialist enforcing tests-first" ;;
    build-error-resolver) desc="Build error resolution specialist" ;;
    e2e-runner)      desc="E2E testing with Playwright" ;;
    doc-updater)     desc="Documentation specialist" ;;
    refactor-cleaner) desc="Dead code cleanup specialist" ;;
    go-build-resolver) desc="Go build error resolution" ;;
    database-reviewer) desc="PostgreSQL optimization specialist" ;;
    rust-build-resolver) desc="Rust/Cargo build error resolution" ;;
  esac

  cat > ".opencode/agents/${name}.md" << EOF
---
description: ${desc}
mode: subagent
tools:
  write: ${write}
  edit: ${edit}
  bash: true
---
${content}
EOF
done

# Add frontmatter to commands
echo "[4/7] Fixing command frontmatter..."
for md in .opencode/commands/*.md; do
  [ -f "$md" ] || continue
  head -1 "$md" | grep -q "^---$" && continue
  name=$(basename "$md" .md)
  content=$(cat "$md")
  cat > "$md" << EOF
---
description: /${name} command
---
${content}
EOF
done

# Copy skills
echo "[5/7] Copying skills..."
for dir in skills/*/; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")
  mkdir -p ".opencode/skills/$name"
  if [ -f "$dir/SKILL.md" ]; then
    cp "$dir/SKILL.md" ".opencode/skills/$name/"
  elif ls "$dir"*.md >/dev/null 2>&1; then
    cat "$dir"*.md > ".opencode/skills/$name/SKILL.md" 2>/dev/null
  fi
done

# Remove old prompt dir and build files
echo "[6/7] Cleaning old build artifacts..."
rm -rf .opencode/prompts
rm -f .opencode/index.ts .opencode/tsconfig.json .opencode/MIGRATION.md
rm -f .opencode/package-lock.json .opencode/package.json .opencode/README.md
rm -f .opencode/instructions/INSTRUCTIONS.md
rmdir .opencode/instructions 2>/dev/null || true

# Update opencode.json (remove agent block, keep commands)
echo "[7/7] Updating opencode.json..."
cat .opencode/opencode.json | jq 'del(.agent)' > .opencode/opencode-new.json
mv .opencode/opencode-new.json .opencode/opencode.json

# Copy to repo
echo ""
echo "Copying to repo..."
rsync -av --delete \
  --exclude='.git' \
  --exclude='.opencode/prompts' \
  "$WORKDIR/.opencode/" "$REPO_DIR/.opencode/"
cp "$WORKDIR/AGENTS.md" "$REPO_DIR/" 2>/dev/null || true
cp "$WORKDIR/CONTRIBUTING.md" "$REPO_DIR/" 2>/dev/null || true

# Commit
cd "$REPO_DIR"
ECC_COMMIT=$(cd "$WORKDIR" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
DATE=$(date +%Y-%m-%d)

# Update SYNC.md with last sync info
sed -i.bak "s/\*\*Last synced:\*\* .*/\*\*Last synced:\*\* ${DATE}/" SYNC.md
sed -i.bak "s/\*\*ECC commit:\*\* .*/\*\*ECC commit:\*\* ${ECC_COMMIT}/" SYNC.md
rm -f SYNC.md.bak

git add -A
git status --short | head -20
echo ""
git commit -m "sync: pull from ECC ${ECC_COMMIT} (${DATE})

One-way sync from affaan-m/everything-claude-code.
Converted to OpenCode-native format.
See SYNC.md for sync policy." 2>/dev/null || echo "No changes to commit"

# Cleanup
rm -rf "$WORKDIR"

echo ""
echo "=== Done ==="
echo "ECC commit: ${ECC_COMMIT}"
echo "Date: ${DATE}"
echo ""
echo "Push with: git push origin main"
