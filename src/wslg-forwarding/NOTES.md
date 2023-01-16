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