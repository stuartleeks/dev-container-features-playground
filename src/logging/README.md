# Logging (logging)

Logs dev container lifecycle events with timestamps and parameters to a file. Useful for debugging and inspecting how features behave — especially when a feature is specified multiple times (e.g. in both user-level and project-level devcontainer.json).

## Usage

Add the feature to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/<owner>/dev-container-features-playground/logging:1": {
            "id": "project",
            "message": "project-config"
        }
    }
}
```

### Testing multiple instances

To observe how features behave when specified from different sources, use a different `id` at each level. Each instance gets its own log file and hook scripts, so they don't interfere.

In your project `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/<owner>/dev-container-features-playground/logging:1": {
            "id": "project",
            "message": "from-project"
        }
    }
}
```

In your VS Code user settings (`dev.containers.defaultFeatures`):

```json
{
    "ghcr.io/<owner>/dev-container-features-playground/logging:1": {
        "id": "user",
        "message": "from-user-settings"
    }
}
```

After the container starts, inspect the logs:

```bash
cat /dc/feature-log/project.log
cat /dc/feature-log/user.log
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `id` | string | `default` | Unique identifier for this instance. Drives script and log file names so multiple instances don't collide. |
| `message` | string | `default` | A label to include in log entries |

## Log format

Each log line follows the format:

```
[<ISO-8601 timestamp>] hook=<phase> id=<id> message="<message>"
```

Log files are written to `/dc/feature-log/<id>.log`.

### Phases logged

| Phase | When |
|-------|------|
| `install` | During container image build (`install.sh`) |
| `oncreate` | `onCreateCommand` lifecycle hook |
| `postcreate` | `postCreateCommand` lifecycle hook |
| `poststart` | `postStartCommand` lifecycle hook |
| `postattach` | `postAttachCommand` lifecycle hook |

## How it handles multiple instances

Each instance registers itself under `/dc/feature-log/instances/<id>.env` and creates per-instance hook scripts at `/dc/feature-log/hooks/<hook>-<id>.sh`. Shared dispatcher scripts (`oncreate.sh`, etc.) run all registered per-instance scripts, so every instance logs independently to its own file.
