#!/usr/bin/env bash
set -e

echo "Activating feature 'logging'..."

MESSAGE="${MESSAGE:-"default"}"
LOG_FILE="${LOG_FILE:-"/dc/feature-log/lifecycle.log"}"

INSTANCE_DIR="/dc/feature-log/instances"
HOOKS_DIR="/dc/feature-log/hooks"

mkdir -p "$INSTANCE_DIR" "$HOOKS_DIR" "$(dirname "$LOG_FILE")"

# Determine instance number based on existing registrations
INSTANCE_NUM=$(ls -1 "$INSTANCE_DIR"/*.env 2>/dev/null | wc -l)

# Register this instance with its parameters
cat > "$INSTANCE_DIR/${INSTANCE_NUM}.env" <<EOF
MESSAGE="$MESSAGE"
LOG_FILE="$LOG_FILE"
EOF

echo "Registered logging instance $INSTANCE_NUM (message='$MESSAGE', log_file='$LOG_FILE')"

# Create lifecycle hook runner scripts (idempotent - same script for all instances)
for HOOK in oncreate postcreate poststart postattach; do
    cat > "$HOOKS_DIR/${HOOK}.sh" <<'HOOKSCRIPT'
#!/usr/bin/env bash
HOOK_NAME="$(basename "$0" .sh)"
INSTANCE_DIR="/dc/feature-log/instances"

for ENV_FILE in "$INSTANCE_DIR"/*.env; do
    [ -f "$ENV_FILE" ] || continue
    INSTANCE="$(basename "$ENV_FILE" .env)"
    # Source the instance's parameters
    source "$ENV_FILE"
    TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%S.%3NZ')"
    LOG_LINE="[$TIMESTAMP] hook=$HOOK_NAME instance=$INSTANCE message=\"$MESSAGE\" log_file=\"$LOG_FILE\""
    echo "$LOG_LINE" >> "$LOG_FILE"
    echo "$LOG_LINE"
done
HOOKSCRIPT
    chmod +x "$HOOKS_DIR/${HOOK}.sh"
done

# Log the install event itself
TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%S.%3NZ')"
LOG_LINE="[$TIMESTAMP] hook=install instance=$INSTANCE_NUM message=\"$MESSAGE\" log_file=\"$LOG_FILE\""
echo "$LOG_LINE" >> "$LOG_FILE"
echo "$LOG_LINE"

echo "Done! Logging feature instance $INSTANCE_NUM installed."
