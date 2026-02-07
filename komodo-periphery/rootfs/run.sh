#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Komodo Periphery
# Starts Komodo Periphery server for remote container management
# ==============================================================================

declare core_url
declare passkey
declare ssl_enabled
declare logging_level
declare disable_terminals
declare disable_container_exec
declare monitoring_interval
declare container_stats_interval
declare stack_directory
declare repo_directory
declare build_directory
declare include_disk_mounts
declare exclude_disk_mounts

# Get configuration from Home Assistant
core_url=$(bashio::config 'core_url' '')
passkey=$(bashio::config 'passkey' '')
ssl_enabled=$(bashio::config 'ssl_enabled' 'false')
logging_level=$(bashio::config 'logging_level' 'info')
disable_terminals=$(bashio::config 'disable_terminals' 'false')
disable_container_exec=$(bashio::config 'disable_container_exec' 'false')
monitoring_interval=$(bashio::config 'monitoring_interval' '30-sec')
container_stats_interval=$(bashio::config 'container_stats_interval' '1-min')
stack_directory=$(bashio::config 'stack_directory' '/share/komodo/stacks')
repo_directory=$(bashio::config 'repo_directory' '/share/komodo/repos')
build_directory=$(bashio::config 'build_directory' '/share/komodo/builds')

# Fallback to environment variables if bashio config is not available
if [ "$core_url" = "null" ] || [ -z "$core_url" ]; then
    core_url="${core_url:-}"
fi
if [ "$passkey" = "null" ] || [ -z "$passkey" ]; then
    passkey="${passkey:-}"
fi
if [ "$ssl_enabled" = "null" ]; then
    ssl_enabled="${ssl_enabled:-false}"
fi
if [ "$logging_level" = "null" ]; then
    logging_level="${logging_level:-info}"
fi

# Set bashio log level based on configuration
case "${logging_level}" in
    "debug")
        bashio::log.level debug
        ;;
    "info")
        bashio::log.level info
        ;;
    "warning")
        bashio::log.level warning
        ;;
    "error")
        bashio::log.level error
        ;;
    *)
        bashio::log.level info
        ;;
esac

bashio::log.info "Starting Komodo Periphery server..."
bashio::log.debug "Debug logging is enabled"

# Create necessary directories
mkdir -p "${stack_directory}"
mkdir -p "${repo_directory}"
mkdir -p "${build_directory}"
mkdir -p /etc/komodo/ssl
mkdir -p /data/config
mkdir -p /data/logs

# Generate random passkey if not provided and no core_url is set (standalone mode)
if bashio::var.is_empty "${passkey}" && bashio::var.is_empty "${core_url}"; then
    # Use alternative method if openssl is not available
    if command -v openssl >/dev/null 2>&1; then
        passkey=$(openssl rand -hex 32)
    else
        # Fallback: use /dev/urandom with od
        passkey=$(head -c 32 /dev/urandom | od -A n -t x1 | tr -d ' \n')
    fi
    bashio::log.info "Generated random passkey for authentication: ${passkey}"
fi

# Get Home Assistant internal IP for SSL certificate (prefer IPv4)
# hostname -i can return multiple IPs (IPv6 and IPv4), we need just one IPv4
ALL_IPS=$(hostname -i 2>/dev/null || echo "")
HA_IP=""
for ip in ${ALL_IPS}; do
    # Skip IPv6 addresses (contain colons)
    if [[ ! "${ip}" =~ : ]]; then
        HA_IP="${ip}"
        break
    fi
done
# Fallback if no IPv4 found
if [[ -z "${HA_IP}" ]]; then
    HA_IP=$(ip route get 1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}' || echo "127.0.0.1")
fi
# Final fallback
if [[ -z "${HA_IP}" ]]; then
    HA_IP="127.0.0.1"
fi
bashio::log.debug "Using IP address for SSL certificate: ${HA_IP}"

# Configure Komodo Periphery environment variables
export PERIPHERY_PORT="8120"
export PERIPHERY_BIND_IP="[::]"
export PERIPHERY_ROOT_DIRECTORY="/etc/komodo"

# Directory overrides
export PERIPHERY_STACK_DIR="${stack_directory}"
export PERIPHERY_REPO_DIR="${repo_directory}"
export PERIPHERY_BUILD_DIR="${build_directory}"

# Terminal configuration
export PERIPHERY_DISABLE_TERMINALS="${disable_terminals}"
export PERIPHERY_DISABLE_CONTAINER_EXEC="${disable_container_exec}"

# Monitoring configuration
export PERIPHERY_STATS_POLLING_RATE="${monitoring_interval}"
export PERIPHERY_CONTAINER_STATS_POLLING_RATE="${container_stats_interval}"

# Create minimal periphery config file for core connection mode
if bashio::var.is_empty "${passkey}"; then
    bashio::log.info "Creating config file for core connection mode (no passkeys)"
    cat > /etc/komodo/periphery.config.toml << EOF
# Komodo Periphery Configuration for Core Connection
port = 8120
bind_ip = "[::]"
root_directory = "/etc/komodo"
repo_dir = "${repo_directory}"
stack_dir = "${stack_directory}"
build_dir = "${build_directory}"
disable_terminals = ${disable_terminals}
disable_container_exec = ${disable_container_exec}
stats_polling_rate = "${monitoring_interval}"
container_stats_polling_rate = "${container_stats_interval}"
ssl_enabled = ${ssl_enabled}
ssl_key_file = "/etc/komodo/ssl/key.pem"
ssl_cert_file = "/etc/komodo/ssl/cert.pem"

# Empty passkeys array for core connection
passkeys = []
EOF
else
    bashio::log.info "Creating config file with passkey authentication"
    cat > /etc/komodo/periphery.config.toml << EOF
# Komodo Periphery Configuration with Passkey
port = 8120
bind_ip = "[::]"
root_directory = "/etc/komodo"
repo_dir = "${repo_directory}"
stack_dir = "${stack_directory}"
build_dir = "${build_directory}"
disable_terminals = ${disable_terminals}
disable_container_exec = ${disable_container_exec}
stats_polling_rate = "${monitoring_interval}"
container_stats_polling_rate = "${container_stats_interval}"
ssl_enabled = ${ssl_enabled}
ssl_key_file = "/etc/komodo/ssl/key.pem"
ssl_cert_file = "/etc/komodo/ssl/cert.pem"

# Passkey for authentication
passkeys = ["${passkey}"]
EOF
fi

# SSL configuration
export PERIPHERY_SSL_ENABLED="${ssl_enabled}"
export PERIPHERY_SSL_KEY_FILE="/etc/komodo/ssl/key.pem"
export PERIPHERY_SSL_CERT_FILE="/etc/komodo/ssl/cert.pem"

# Logging configuration
export PERIPHERY_LOGGING_LEVEL="${logging_level}"
export PERIPHERY_LOGGING_STDIO="standard"
export PERIPHERY_LOGGING_PRETTY="false"

# Disk mount filtering
include_mounts=$(bashio::config 'include_disk_mounts')
exclude_mounts=$(bashio::config 'exclude_disk_mounts')

if [[ "${include_mounts}" != "null" && "${include_mounts}" != "[]" ]]; then
    export PERIPHERY_INCLUDE_DISK_MOUNTS="${include_mounts}"
fi

if [[ "${exclude_mounts}" != "null" && "${exclude_mounts}" != "[]" ]]; then
    export PERIPHERY_EXCLUDE_DISK_MOUNTS="${exclude_mounts}"
fi

# Additional config
export TZ="Europe/Berlin"

# SSL Certificate handling - use /data/ssl for persistence across restarts
SSL_DATA_DIR="/data/ssl"
SSL_KOMODO_DIR="/etc/komodo/ssl"

if [[ "${ssl_enabled}" == "true" ]]; then
    mkdir -p "${SSL_DATA_DIR}"
    mkdir -p "${SSL_KOMODO_DIR}"

    # Check for existing certificates in persistent storage
    if [[ -f "${SSL_DATA_DIR}/cert.pem" && -f "${SSL_DATA_DIR}/key.pem" ]]; then
        bashio::log.info "Using existing SSL certificates from persistent storage"
        cp "${SSL_DATA_DIR}/cert.pem" "${SSL_KOMODO_DIR}/cert.pem"
        cp "${SSL_DATA_DIR}/key.pem" "${SSL_KOMODO_DIR}/key.pem"
        chmod 600 "${SSL_KOMODO_DIR}/key.pem"
        chmod 644 "${SSL_KOMODO_DIR}/cert.pem"
    else
        bashio::log.info "Generating self-signed SSL certificates..."

        # Check if openssl is available
        if ! command -v openssl >/dev/null 2>&1; then
            bashio::log.error "OpenSSL is not installed - cannot generate SSL certificates"
            bashio::log.warning "Disabling SSL and continuing without encryption"
            ssl_enabled="false"
            export PERIPHERY_SSL_ENABLED="false"
        else
            # Generate certificates with proper error handling
            if openssl req -x509 -newkey rsa:4096 \
                -keyout "${SSL_DATA_DIR}/key.pem" \
                -out "${SSL_DATA_DIR}/cert.pem" \
                -days 365 -nodes \
                -subj "/C=DE/ST=State/L=City/O=HomeAssistant/OU=Komodo/CN=${HA_IP}" \
                -addext "subjectAltName=IP:${HA_IP},IP:127.0.0.1,DNS:localhost,DNS:homeassistant.local" 2>&1; then

                # Verify certificates were created
                if [[ -f "${SSL_DATA_DIR}/cert.pem" && -f "${SSL_DATA_DIR}/key.pem" ]]; then
                    bashio::log.info "SSL certificates generated successfully"

                    # Copy to komodo directory
                    cp "${SSL_DATA_DIR}/cert.pem" "${SSL_KOMODO_DIR}/cert.pem"
                    cp "${SSL_DATA_DIR}/key.pem" "${SSL_KOMODO_DIR}/key.pem"
                    chmod 600 "${SSL_KOMODO_DIR}/key.pem"
                    chmod 644 "${SSL_KOMODO_DIR}/cert.pem"
                    chmod 600 "${SSL_DATA_DIR}/key.pem"
                    chmod 644 "${SSL_DATA_DIR}/cert.pem"
                else
                    bashio::log.error "SSL certificate files were not created"
                    bashio::log.warning "Disabling SSL and continuing without encryption"
                    ssl_enabled="false"
                    export PERIPHERY_SSL_ENABLED="false"
                fi
            else
                bashio::log.error "Failed to generate SSL certificates"
                bashio::log.warning "Disabling SSL and continuing without encryption"
                ssl_enabled="false"
                export PERIPHERY_SSL_ENABLED="false"
            fi
        fi
    fi

    # Final verification before starting with SSL
    if [[ "${ssl_enabled}" == "true" ]]; then
        if [[ ! -f "${SSL_KOMODO_DIR}/cert.pem" || ! -f "${SSL_KOMODO_DIR}/key.pem" ]]; then
            bashio::log.error "SSL certificates not found in ${SSL_KOMODO_DIR}"
            bashio::log.warning "Disabling SSL and continuing without encryption"
            ssl_enabled="false"
            export PERIPHERY_SSL_ENABLED="false"
        else
            bashio::log.info "SSL certificates verified at ${SSL_KOMODO_DIR}"
        fi
    fi
fi

# Update config file if SSL was disabled during certificate generation
# This ensures the config matches the actual SSL state
sed -i "s/ssl_enabled = true/ssl_enabled = ${ssl_enabled}/" /etc/komodo/periphery.config.toml

bashio::log.info "Komodo Periphery configuration prepared"
bashio::log.info "Stack directory: ${stack_directory}"
bashio::log.info "Repo directory: ${repo_directory}"
bashio::log.info "Build directory: ${build_directory}"
bashio::log.info "SSL enabled: ${ssl_enabled}"
bashio::log.info "Passkey: ${passkey}"

if [[ -n "${core_url}" ]]; then
    bashio::log.info "Core URL: ${core_url}"
    bashio::log.info "This periphery is configured to connect to a remote core"
else
    bashio::log.info "No core URL configured - this periphery runs standalone"
fi

# Check if Komodo Periphery binary exists and is executable
if [ -x "/usr/local/bin/periphery" ]; then
    bashio::log.info "Found Komodo Periphery binary at /usr/local/bin/periphery"
    
    # Set library path for glibc compatibility and suppress warnings
    export LD_LIBRARY_PATH="/usr/glibc-compat/lib:/lib:/usr/lib:/usr/lib64:/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export LD_PRELOAD=""
    
    # Set environment to suppress version warnings
    export LD_WARN_VERSION=no
    export GLIBC_TUNABLES=glibc.elision.enable=0
    
    bashio::log.info "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
    bashio::log.debug "Library warnings suppressed for binary compatibility"
    
    # Simplified binary verification - just check if it exists and proceed
    bashio::log.info "Performing basic binary verification..."
    
    if [ -x "/usr/local/bin/periphery" ]; then
        bashio::log.info "Binary is executable"
        
        # Get basic file information with timeout
        if command -v file >/dev/null 2>&1; then
            bashio::log.info "Getting binary information..."
            if timeout 5 file /usr/local/bin/periphery >/tmp/file_info.out 2>&1; then
                file_info=$(cat /tmp/file_info.out)
                bashio::log.info "Binary type: $file_info"
            else
                bashio::log.warning "File command timed out or failed"
            fi
            rm -f /tmp/file_info.out
        fi
        
        bashio::log.info "Binary verification complete - proceeding with startup"
    else
        bashio::log.error "Binary is not executable"
        exit 1
    fi
    
    bashio::log.info "Starting Komodo Periphery..."
    bashio::log.debug "Executing with native glibc (Debian)"
    bashio::log.debug "Working directory: $(pwd)"
    
    # Export all variables for debugging
    bashio::log.debug "Environment summary:"
    bashio::log.debug "PORT: $PERIPHERY_PORT"
    bashio::log.debug "BIND_IP: $PERIPHERY_BIND_IP"
    bashio::log.debug "SSL_ENABLED: $PERIPHERY_SSL_ENABLED"
    if [ -n "${PERIPHERY_PASSKEYS:-}" ]; then
        bashio::log.debug "PASSKEYS: ${PERIPHERY_PASSKEYS:0:10}..."
    else
        bashio::log.debug "PASSKEYS: (using config file)"
    fi
    
    # Start Komodo Periphery using native glibc
    bashio::log.info "Attempting to start Komodo Periphery binary..."
    
    # Test binary availability first
    if [ ! -f "/usr/local/bin/periphery" ]; then
        bashio::log.error "Komodo Periphery binary not found at /usr/local/bin/periphery"
        exit 1
    fi
    
    # Make sure binary is executable
    chmod +x /usr/local/bin/periphery
    
    # Check binary type and compatibility
    bashio::log.debug "Binary information:"
    file /usr/local/bin/periphery 2>/dev/null | head -1 || bashio::log.debug "file command failed"
    
    # Check library dependencies
    bashio::log.debug "Library dependencies:"
    ldd /usr/local/bin/periphery 2>/dev/null || bashio::log.debug "ldd failed"
    
    # Try to start the binary directly (native glibc should work)
    bashio::log.info "Starting Komodo Periphery with native glibc..."
    
    if ! /usr/local/bin/periphery 2>&1; then
        exit_code=$?
        bashio::log.error "Komodo Periphery failed to start (exit code: $exit_code)"
        
        # Additional debugging
        bashio::log.info "System information:"
        uname -a 2>/dev/null || bashio::log.info "uname failed"
        
        bashio::log.info "Glibc version:"
        /lib/x86_64-linux-gnu/libc.so.6 2>/dev/null || bashio::log.info "glibc version check failed"
        
        exit $exit_code
    fi
else
    bashio::log.error "Komodo Periphery binary not found at /usr/local/bin/periphery"
    exit 1
fi
