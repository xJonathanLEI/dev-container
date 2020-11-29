# Dev Container for VS Code Remote

This repository contains files for building an ideal development container for use with [Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview).

It's highly opinionated as it's meant for my own use.

## Configuration

The container is configurable through environment variables.

If you don't supply OpenSSH host keys they'll simply be randomly generated. However, it's highly recommended that you set them, or you'll get a key conflict every time you re-create the container.

For convenience, by default the container can be logged in with an empty password as user `dev`. It's recommended that you disable password login by setting `SSH_KEY`.

### SSH_PORT

The port the OpenSSH server listens on. Defaults to `22`.

### SSH_KEY

The public key for SSH login. Password login (with empty password) if disabled if and only if `SSH_KEY` is supplied.

### SSH_HOST_DSA_KEY

The base64-encoded DSA host private key used by the OpenSSH server.

### SSH_HOST_ECDSA_KEY

The base64-encoded ECDSA host private key used by the OpenSSH server.

### SSH_HOST_ED25519_KEY

The base64-encoded ED25519 host private key used by the OpenSSH server.

### SSH_HOST_RSA_KEY

The base64-encoded RSA host private key used by the OpenSSH server.

### ADB_KEY

The base64-encoded private key used for ADB. A random key will be generated the first time you use ADB if not configured.

To encode your existing key (which most likely lives at `${HOME}/.android/adbkey`):

    $ cat /path/to/adb/key | base64 -w 0
