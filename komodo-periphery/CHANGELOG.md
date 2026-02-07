## What's changed

## Version 2.1.0
- Updated Docker CLI installation to use official Docker repository for better API compatibility
- S6-overlay now automatically fetches the latest version at build time
- Bashio now automatically fetches the latest version at build time
- Fixed IPv4/IPv6 handling for SSL certificate generation
- Improved SSL certificate handling with persistent storage across add-on restarts
- Enhanced SSL error handling with graceful fallback to non-SSL mode

## Version 2.0.0
- Updated add-on version to 2.0.0
- Add-on now always uses the latest version of Komodo Periphery from upstream
- Komodo Periphery binary is pulled from the official `ghcr.io/moghtech/komodo-periphery:latest` image at build time
- The add-on version is now independent of the underlying Komodo Periphery version

## Version 1.18.4
- Initial release of Komodo Periphery Home Assistant Add-on
- Support for Komodo Periphery (initially v1.18.4)
- Docker container management capabilities
- Core connection mode and standalone mode support
- SSL/TLS encryption support
- Multi-architecture support (amd64, aarch64)
