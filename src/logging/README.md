
# Logging (logging)

Logs lifecycle events with timestamps and parameters to a file. Supports being specified multiple times to inspect feature merge behavior.

## Example Usage

```json
"features": {
    "ghcr.io/stuartleeks/dev-container-features-playground/logging:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| message | A label/message to include in log entries, useful for identifying which instance produced the log line | string | default |
| log_file | Path to the log file | string | /dc/feature-log/lifecycle.log |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/stuartleeks/dev-container-features-playground/blob/main/src/logging/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
