# Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.18.x  | :white_check_mark: |
| < 1.18  | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please follow these steps:

### 1. Do NOT create a public issue

Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.

### 2. Send a private report

Instead, please send an email to [your-security-email@domain.com] with the following information:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit the issue

### 3. What to expect

- You will receive a response within 48 hours acknowledging receipt of your report
- We will investigate the issue and provide an initial assessment within 5 business days
- We will keep you informed of our progress throughout the investigation
- We will notify you when the issue is fixed

### 4. Responsible disclosure

We request that you:

- Give us reasonable time to fix the issue before making it public
- Do not access or modify data that doesn't belong to you
- Do not perform actions that could harm our service or users
- Do not share the vulnerability with others until we have addressed it

## Security Best Practices

When using this add-on:

1. **Use strong passkeys**: If using standalone mode, ensure your passkey is strong and unique
2. **Enable SSL**: Use SSL/TLS encryption in production environments
3. **Limit network access**: Restrict network access to the add-on to authorized sources only
4. **Keep updated**: Always use the latest version of the add-on
5. **Monitor logs**: Regularly review add-on logs for suspicious activity
6. **Docker security**: Follow Docker security best practices for the underlying system

## Known Security Considerations

- The add-on requires access to the Docker socket, which provides significant system access
- Network traffic may be unencrypted if SSL is disabled
- Container exec functionality provides shell access to containers
- Terminal functionality may expose sensitive information in logs

Thank you for helping to keep our project secure!
