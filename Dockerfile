FROM alpine:latest

# Install dante-server and network tools
RUN apk add --no-cache dante-server iproute2

# Create a startup script that detects the interface
RUN cat > /start.sh <<'EOF'
#!/bin/sh

# Get the default route interface
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
echo "Detected interface: $INTERFACE"

# Create config with detected interface
cat > /etc/sockd.conf <<CONF
logoutput: stderr
internal: 0.0.0.0 port = 1080
external: $INTERFACE
socksmethod: none
clientmethod: none
client pass { from: 0.0.0.0/0 to: 0.0.0.0/0 log: error }
socks pass { from: 0.0.0.0/0 to: 0.0.0.0/0 protocol: tcp udp log: error }
CONF

echo "Starting sockd with config:"
cat /etc/sockd.conf

# Start sockd
exec sockd -f /etc/sockd.conf -D
EOF

RUN chmod +x /start.sh

EXPOSE 1080

CMD ["/start.sh"]
