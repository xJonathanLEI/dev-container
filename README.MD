# Dev Container for VS Code Remote

This repository contains files for building an ideal development container for use with [Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview).

It's highly opinionated as it's meant for my own use.

## Configuration

The container is configurable through environment variables.

### PORT

The port the OpenSSH server listens on. Defaults to `22`.

### ADB_KEY

The base64-encoded private key used for ADB. A random key will be generated the first time you use ADB if not configured.

To encode your existing key (which most likely lives at `${HOME}/.android/adbkey`):

    $ cat /path/to/adb/key | base64 -w 0
