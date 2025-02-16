# Dev Container for VS Code Remote

This repository contains files for building an ideal development container for use with [Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview).

It's highly opinionated as it's meant for my own use.

## Configuration

The container is configurable through environment variables.

If you don't supply OpenSSH host keys they'll simply be randomly generated. However, it's highly recommended that you set them, or you'll get a key conflict every time you re-create the container.

For convenience, by default the container can be logged in with an empty password as user `dev`. It's recommended that you disable password login by setting `SSH_KEYS`.

### SSH_PORT

The port the OpenSSH server listens on. Defaults to `22`.

### SSH_KEYS

Public keys for SSH login. Multiple keys are separated by comma `,`. Password login (with empty password) if disabled if and only if `SSH_KEYS` is supplied.

### SSH_HOST_DSA_KEY

The base64-encoded DSA host private key used by the OpenSSH server.

### SSH_HOST_ECDSA_KEY

The base64-encoded ECDSA host private key used by the OpenSSH server.

### SSH_HOST_ED25519_KEY

The base64-encoded ED25519 host private key used by the OpenSSH server.

### SSH_HOST_RSA_KEY

The base64-encoded RSA host private key used by the OpenSSH server.

### STARTUP_COMMAND

An optional command to run during container startup.
