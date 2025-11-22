# Contributing to Komodo Periphery Home Assistant Add-on

Thank you for your interest in contributing to the Komodo Periphery Home Assistant Add-on! We welcome contributions from the community.

## Getting Started

1. Fork this repository
2. Clone your fork locally
3. Create a new branch for your feature or bug fix
4. Make your changes
5. Test your changes thoroughly
6. Submit a pull request

## Development Setup

### Prerequisites

- Docker
- Home Assistant development environment (optional but recommended)
- Basic knowledge of Docker, Bash scripting, and Home Assistant Add-ons

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/cgfm/Komodo-Periphery-Addon.git
   cd hassio-addon-komodo-periphery
   ```

2. Build the add-on locally:
   ```bash
   docker build -t komodo-periphery-addon .
   ```

3. Test the add-on:
   ```bash
   docker run --rm -it \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -p 8120:8120 \
     komodo-periphery-addon
   ```

## Code Style

- Follow existing code patterns and style
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure proper error handling

## Testing

Before submitting a pull request:

1. **Build Test**: Ensure the Docker image builds successfully
2. **Functionality Test**: Test basic add-on functionality
3. **Configuration Test**: Test various configuration scenarios
4. **Architecture Test**: If possible, test on different architectures

### Test Scenarios

- [ ] Add-on starts successfully with default configuration
- [ ] Core connection mode works with valid core_url
- [ ] Standalone mode works with passkey authentication
- [ ] Container management functions properly
- [ ] Health checks pass
- [ ] Configuration validation works correctly

## Pull Request Process

1. **Description**: Provide a clear description of what your PR does
2. **Testing**: Include information about how you tested your changes
3. **Documentation**: Update documentation if needed
4. **Changelog**: Add an entry to CHANGELOG.md if appropriate

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Other (please describe)

## Testing
- [ ] Tested locally
- [ ] Tested in Home Assistant
- [ ] Tested with Komodo Core connection
- [ ] Tested standalone mode

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
- [ ] Changelog updated (if needed)
```

## Reporting Issues

When reporting issues, please include:

- Home Assistant version
- Add-on version
- Configuration (sanitized)
- Error logs
- Steps to reproduce

## Feature Requests

Feature requests are welcome! Please provide:

- Clear description of the feature
- Use case and motivation
- Any relevant examples or references

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help newcomers and answer questions
- Follow GitHub's Community Guidelines

## Questions?

If you have questions about contributing, feel free to:

- Open an issue with the "question" label
- Start a discussion in the repository
- Reach out to the maintainers

Thank you for contributing! 🎉
