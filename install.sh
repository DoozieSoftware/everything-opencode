#!/bin/bash
# install.sh — Install everything-opencode
#
# Usage:
#   ./install.sh --target global     # Install to ~/.config/opencode/ (all projects)
#   ./install.sh --target project    # Install to current directory (per-project)
#   ./install.sh                     # Default: global

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_VAL="${2:-global}"

install_global() {
  echo "Installing globally to ~/.config/opencode/..."
  mkdir -p ~/.config/opencode/{agents,commands,skills,plugins,tools}

  cp "$SCRIPT_DIR/.opencode/agents/"*.md     ~/.config/opencode/agents/
  cp "$SCRIPT_DIR/.opencode/commands/"*.md   ~/.config/opencode/commands/
  cp -r "$SCRIPT_DIR/.opencode/skills/"*     ~/.config/opencode/skills/ 2>/dev/null || true
  cp "$SCRIPT_DIR/.opencode/plugins/"*       ~/.config/opencode/plugins/ 2>/dev/null || true
  cp "$SCRIPT_DIR/.opencode/tools/"*         ~/.config/opencode/tools/ 2>/dev/null || true
  cp "$SCRIPT_DIR/AGENTS.md"                 ~/.config/opencode/ 2>/dev/null || true

  # Merge commands into global config
  if [ -f ~/.config/opencode/opencode.json ]; then
    echo "Merging commands into ~/.config/opencode/opencode.json..."
    ECC_CMD=$(cat "$SCRIPT_DIR/.opencode/opencode.json" | jq '.command // {}')
    ECC_INS=$(cat "$SCRIPT_DIR/.opencode/opencode.json" | jq '.instructions // []')

    cat ~/.config/opencode/opencode.json | jq \
      --argjson commands "$ECC_CMD" \
      --argjson instructions "$ECC_INS" \
      '.command = ((.command // {}) + $commands) |
       .instructions = ((.instructions // []) + $instructions | unique)' \
      > /tmp/ecc-merged.json
    cp /tmp/ecc-merged.json ~/.config/opencode/opencode.json
    rm /tmp/ecc-merged.json
  else
    cp "$SCRIPT_DIR/.opencode/opencode.json" ~/.config/opencode/opencode.json
  fi

  echo ""
  echo "Installed globally."
  echo "  agents:   $(ls ~/.config/opencode/agents/*.md | wc -l | tr -d ' ')"
  echo "  commands: $(ls ~/.config/opencode/commands/*.md | wc -l | tr -d ' ')"
  echo "  skills:   $(find ~/.config/opencode/skills -name 'SKILL.md' | wc -l | tr -d ' ')"
  echo ""
  echo "Run 'opencode' in any project."
}

install_project() {
  echo "Installing to current project..."
  cp -r "$SCRIPT_DIR/.opencode" .
  cp "$SCRIPT_DIR/AGENTS.md" . 2>/dev/null || true
  echo ""
  echo "Installed to .opencode/"
  echo "Run 'opencode' from this directory."
}

case "${2:-global}" in
  global)
    install_global
    ;;
  project)
    install_project
    ;;
  *)
    echo "Usage: ./install.sh --target [global|project]"
    exit 1
    ;;
esac
