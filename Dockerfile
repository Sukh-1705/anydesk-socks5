FROM alpine:latest

# Install 3proxy (simpler, more reliable)
RUN apk add --no-cache 3proxy

# Create minimal config
RUN cat > /etc/3proxy.cfg <<'EOF'
# Simple SOCKS5 proxy config
daemon
nserver 8.8.8.8
nscache 65536
auth none
allow *
socks -p1080
EOF

EXPOSE 1080

CMD ["3proxy", "/etc/3proxy.cfg"]
