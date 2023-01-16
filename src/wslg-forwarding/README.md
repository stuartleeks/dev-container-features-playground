
# WSLg forwarding (wslg-forwarding)

Forward 

## Example Usage

```json
"features": {
    "ghcr.io/stuartleeks/dev-container-features-playground/wslg-forwarding:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|


Initially, the following env variables were forwarded into the container:

```json
  "containerEnv": {
    "DISPLAY": "${localEnv:DISPLAY}",
    "WAYLAND_DISPLAY": "${localEnv:WAYLAND_DISPLAY}",
    "XDG_RUNTIME_DIR": "${localEnv:XDG_RUNTIME_DIR}",
    "PULSE_SERVER": "${localEnv:PULSE_SERVER}"
  },

```

This resulted in `DISPLAY` being set to `1` in the container rather than `:0`, so it is hard-coded instead

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/stuartleeks/dev-container-features-playground/blob/main/src/wslg-forwarding/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
