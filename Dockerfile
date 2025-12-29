FROM alpine:latest

# Install dante-server
RUN apk add --no-cache dante-server

# Create a minimal working config
RUN cat > /etc/sockd.conf <<EOF
# Logging
logoutput: stderr

# Listen on all interfaces
internal: 0.0.0.0 port = 1080

# Use default route interface
external.rotation: route

# No authentication
clientmethod: none
socksmethod: none

# Allow all clients
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
}

# Allow all SOCKS traffic
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    command: bind connect udpassociate
    log: error
}
EOF

EXPOSE 1080

# Run sockd in debug mode to see errors
CMD ["sockd", "-f", "/etc/sockd.conf", "-d", "1"]
