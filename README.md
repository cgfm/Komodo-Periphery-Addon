# Home Assistant Add-on: Komodo Periphery

[![GitHub Release][releases-shield]][releases]
[![GitHub Activity][commits-shield]][commits]
[![License][license-shield]](LICENSE)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

_Komodo Periphery Server - Manages containers on remote servers_

![banner][banner-image]

## About

This Home Assistant Add-on provides the Komodo Periphery server, which allows you to manage Docker containers on remote servers through the Komodo platform. The Periphery server acts as an agent that connects to a Komodo Core server and executes container management tasks.

**Note:** This add-on automatically uses the latest stable version of Komodo Periphery from the official upstream repository. The add-on version number (2.x) is independent of the underlying Komodo Periphery version to provide clear versioning for the Home Assistant integration.

## Features

- 🐳 **Docker Container Management**: Full Docker container lifecycle management
- 🔗 **Core Connection**: Seamless connection to Komodo Core servers
- 📊 **Container Statistics**: Real-time monitoring of container performance
- 🔒 **Secure Authentication**: Support for passkey-based authentication
- 📁 **Stack Management**: Deploy and manage Docker Compose stacks
- 🏗️ **Build Support**: Build Docker images from repositories
- 🌐 **SSL Support**: Optional SSL/TLS encryption
- 📋 **Repository Management**: Git repository integration

## Installation

### Quick Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fcgfm%2FKomodo-Periphery-Addon)

### Manual Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**.
2. Click the 3-dots menu at upper right **...** → **Repositories** and add this repository URL:
   ```
   https://github.com/cgfm/Komodo-Periphery-Addon
   ```
3. Find the "Komodo Periphery" add-on and click it.
4. Click on the "INSTALL" button.

## How to use

### Basic Configuration

The most common configuration connects this Periphery to a remote Komodo Core server:

```yaml
core_url: "ws://your-core-server:9120"
monitoring_interval: "30-sec"
container_stats_interval: "1-min"
ssl_enabled: false
```

### Standalone Mode

For standalone operation with passkey authentication:

```yaml
passkey: "your-secure-passkey"
monitoring_interval: "30-sec"
container_stats_interval: "1-min"
ssl_enabled: true
```

### Advanced Configuration

```yaml
core_url: "wss://core.example.com:9120"
passkey: "optional-additional-security"
monitoring_interval: "1-min"
container_stats_interval: "5-min"
ssl_enabled: true
stack_directory: "/share/komodo/stacks"
repo_directory: "/share/komodo/repos"
build_directory: "/share/komodo/builds"
disable_terminals: false
disable_container_exec: false
```

## Configuration

### Option: `core_url` (optional)

WebSocket URL of the Komodo Core server to connect to. When specified, this Periphery will operate in "Core Connection Mode" and connect to the specified Core server.

**Format**: `ws://hostname:port` or `wss://hostname:port` for SSL

### Option: `passkey` (optional)

Authentication passkey for securing access to the Periphery server. Required for standalone mode, optional for core connection mode.

### Option: `monitoring_interval`

Interval for system monitoring tasks.

**Default**: `30-sec`
**Valid values**: `10-sec`, `30-sec`, `1-min`, `5-min`, `10-min`

### Option: `container_stats_interval`

Interval for collecting container statistics.

**Default**: `1-min`
**Valid values**: `30-sec`, `1-min`, `5-min`, `10-min`

### Option: `ssl_enabled`

Enable SSL/TLS encryption for the Periphery server.

**Default**: `false`

### Option: `stack_directory`

Directory path for storing Docker Compose stacks.

**Default**: `/share/komodo/stacks`

### Option: `repo_directory`

Directory path for storing Git repositories.

**Default**: `/share/komodo/repos`

### Option: `build_directory`

Directory path for Docker build contexts.

**Default**: `/share/komodo/builds`

### Option: `disable_terminals`

Disable terminal access functionality.

**Default**: `false`

### Option: `disable_container_exec`

Disable container exec functionality.

**Default**: `false`

## Network Requirements

- **Port 8120**: Komodo Periphery web interface and API
- **Docker Socket**: Access to `/var/run/docker.sock` for container management
- **Outbound Connection**: To Komodo Core server (if configured)

## Known Issues and Limitations

- The add-on requires access to the Docker socket
- SSL certificates must be manually configured if SSL is enabled
- Some container statistics require privileged access

## Support

Got questions?

You could [open an issue here][issue] GitHub.

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We have set up a separate document containing our
[contribution guidelines](.github/CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## License

MIT License

Copyright (c) 2024-2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[banner-image]: https://raw.githubusercontent.com/cgfm/Komodo-Periphery-Addon/refs/heads/main/images/banner.png
[commits-shield]: https://img.shields.io/github/commit-activity/y/cgfm/Komodo-Periphery-Addon.svg
[commits]: https://github.com/cgfm/Komodo-Periphery-Addon/commits/main
[contributors]: https://github.com/cgfm/Komodo-Periphery-Addon/graphs/contributors
[author]: https://github.com/cgfm
[issue]: https://github.com/cgfm/Komodo-Periphery-Addon/issues
[license-shield]: https://img.shields.io/github/license/cgfm/Komodo-Periphery-Addon.svg
[releases-shield]: https://img.shields.io/github/release/cgfm/Komodo-Periphery-Addon.svg
[releases]: https://github.com/cgfm/Komodo-Periphery-Addon/releases
