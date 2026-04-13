#!/usr/bin/env bash
set -e

echo "Activating feature 'logging'..."

ID="${ID:-"default"}"
MESSAGE="${MESSAGE:-"default"}"
LOG_FILE="/dc/feature-log/${ID}.log"

HOOKS_DIR="/dc/feature-log/hooks"
INSTANCE_DIR="/dc/feature-log/instances"

mkdir -p "$HOOKS_DIR" "$INSTANCE_DIR" "$(dirname "$LOG_FILE")"

# Register this instance
cat > "$INSTANCE_DIR/${ID}.env" <<EOF
ID="$ID"
MESSAGE="$MESSAGE"
LOG_FILE="$LOG_FILE"
EOF

echo "Registered logging instance (id='$ID', message='$MESSAGE', log_file='$LOG_FILE')"

# Create per-instance lifecycle hook scripts (named by ID so instances don't collide)
for HOOK in oncreate postcreate poststart postattach; do
    cat > "$HOOKS_DIR/${HOOK}-${ID}.sh" <<HOOKSCRIPT
#!/usr/bin/env bash
ID="$ID"
MESSAGE="$MESSAGE"
LOG_FILE="$LOG_FILE"
HOOK_NAME="$HOOK"
TIMESTAMP="\$(date -u '+%Y-%m-%dT%H:%M:%S.%3NZ')"
LOG_LINE="[\$TIMESTAMP] hook=\$HOOK_NAME id=\$ID message=\"\$MESSAGE\""
echo "\$LOG_LINE" >> "\$LOG_FILE"
echo "\$LOG_LINE"
HOOKSCRIPT
    chmod +x "$HOOKS_DIR/${HOOK}-${ID}.sh"
done

# Create shared dispatcher scripts that run all per-instance scripts for each hook
# These are idempotent - safe to overwrite on each install
for HOOK in oncreate postcreate poststart postattach; do
    cat > "$HOOKS_DIR/${HOOK}.sh" <<'DISPATCHER'
#!/usr/bin/env bash
HOOK_NAME="$(basename "$0" .sh)"
HOOKS_DIR="$(dirname "$0")"
for SCRIPT in "$HOOKS_DIR/${HOOK_NAME}"-*.sh; do
    [ -f "$SCRIPT" ] || continue
    "$SCRIPT"
done
DISPATCHER
    chmod +x "$HOOKS_DIR/${HOOK}.sh"
done

# Log the install event
TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%S.%3NZ')"
LOG_LINE="[$TIMESTAMP] hook=install id=$ID message=\"$MESSAGE\""
echo "$LOG_LINE" >> "$LOG_FILE"
echo "$LOG_LINE"

echo "Done! Logging feature instance '$ID' installed."
