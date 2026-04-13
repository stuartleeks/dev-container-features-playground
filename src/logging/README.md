# Logging (logging)

Logs dev container lifecycle events with timestamps and parameters to a file. Useful for debugging and inspecting how features behave — especially when a feature is specified multiple times (e.g. in both user-level and project-level devcontainer.json).

## Usage

Add the feature to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/<owner>/dev-container-features-playground/logging:1": {
            "message": "project-config",
            "log_file": "/dc/feature-log/lifecycle.log"
        }
    }
}
```

### Testing multiple instances

To observe how features behave when specified multiple times, add the feature at different levels or with different options:

```json
{
    "features": {
        "ghcr.io/<owner>/dev-container-features-playground/logging:1": {
            "message": "first-instance"
        }
    }
}
```

And in a second configuration (e.g. user-level settings):

```json
{
    "features": {
        "ghcr.io/<owner>/dev-container-features-playground/logging:1": {
            "message": "second-instance"
        }
    }
}
```

After the container starts, inspect the log:

```bash
cat /dc/feature-log/lifecycle.log
```

You'll see entries for each lifecycle phase from each instance, making it clear how features are merged and executed.

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `message` | string | `default` | A label to include in log entries, useful for identifying which instance produced the line |
| `log_file` | string | `/dc/feature-log/lifecycle.log` | Path to the log file |

## Log format

Each log line follows the format:

```
[<ISO-8601 timestamp>] hook=<phase> instance=<N> message="<message>" log_file="<path>"
```

### Phases logged

| Phase | When |
|-------|------|
| `install` | During container image build (`install.sh`) |
| `oncreate` | `onCreateCommand` lifecycle hook |
| `postcreate` | `postCreateCommand` lifecycle hook |
| `poststart` | `postStartCommand` lifecycle hook |
| `postattach` | `postAttachCommand` lifecycle hook |

## How it handles multiple instances

Each time the feature is installed (each instance), it registers itself with a unique instance number under `/dc/feature-log/instances/`. The lifecycle hook scripts iterate over all registered instances and log an entry for each one, so you can see exactly how many times the feature was applied and with what parameters.
