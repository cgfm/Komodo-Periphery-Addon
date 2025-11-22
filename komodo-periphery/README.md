# Home Assistant Add-on: Komodo Periphery

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

_Komodo Periphery Server - Manages containers on remote servers_

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

## Basic Configuration Examples

### Core Connection Mode
```yaml
core_url: "ws://your-core-server:9120"
monitoring_interval: "30-sec"
container_stats_interval: "1-min"
ssl_enabled: false
```

### Standalone Mode
```yaml
passkey: "your-secure-passkey"
monitoring_interval: "30-sec"
container_stats_interval: "1-min"
ssl_enabled: true
```

## Network Requirements

- **Port 8120**: Komodo Periphery web interface and API
- **Docker Socket**: Access to `/var/run/docker.sock` for container management
- **Outbound Connection**: To Komodo Core server (if configured)

## Support

Got questions? [Open an issue](https://github.com/cgfm/Komodo-Periphery-Addon/issues)

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
