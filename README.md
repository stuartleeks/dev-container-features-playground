# Dev Container Features Playground

This repo is my place for experimenting with [dev container features](https://containers.dev/features).

Features in this repo are likely to change/break/disappear as I explore ideas. When I'm happy with a feature, I will move it to [stuartleeks/dev-container-features](https://github.com/stuartleeks/dev-container-features).

If you want to create your own features, see <https://github.com/devcontainers/feature-template>


| Feature                                       | Description                                                                                                                                                           |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [bash-history](src/bash-history/)             | (Precursor to shell-history) Preserve bash history across dev container instances/rebuilds                                                                            |
| [shell-history](src/shell-history/)           | Preserve shell history across dev container instances/rebuilds (see also https://github.com/stuartleeks/dev-container-features/blob/main/src/shell-history/README.md) |
| [shell-history-sync](src/shell-history-sync/) | Temporary utility feature to copy bash history from my manually added volumes to the volume added by shell-history                                                    |
