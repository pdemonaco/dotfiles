# .claude/scripts/validate-bash.sh
COMMAND=$(cat | jq -r '.tool_input.command')
BLOCKED="node_modules|\\.env|__pycache__|\\.git/|dist/|build/|vendor/|spec/fixtures/modules/|"
if echo "$COMMAND" | grep -qE "$BLOCKED"; then
  echo "ERROR: Blocked directory pattern" >&2
  exit 2
fi
