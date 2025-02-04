default:
  @just --list

test-dapr-cli:
	devcontainer features test --features dapr-cli --skip-scenarios --base-image mcr.microsoft.com/devcontainers/base:ubuntu --project-folder .