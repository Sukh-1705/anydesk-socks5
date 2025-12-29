FROM alpine:latest

# Install Dante SOCKS5 server
RUN apk add --no-cache dante-server

# Create minimal config
RUN echo "logoutput: stderr" > /etc/sockd.conf && \
    echo "internal: 0.0.0.0 port = 1080" >> /etc/sockd.conf && \
    echo "external: eth0" >> /etc/sockd.conf && \
    echo "clientmethod: none" >> /etc/sockd.conf && \
    echo "socksmethod: none" >> /etc/sockd.conf && \
    echo "user.privileged: root" >> /etc/sockd.conf && \
    echo "user.unprivileged: nobody" >> /etc/sockd.conf && \
    echo "client pass {" >> /etc/sockd.conf && \
    echo "    from: 0.0.0.0/0 to: 0.0.0.0/0" >> /etc/sockd.conf && \
    echo "    log: error" >> /etc/sockd.conf && \
    echo "}" >> /etc/sockd.conf && \
    echo "socks pass {" >> /etc/sockd.conf && \
    echo "    from: 0.0.0.0/0 to: 0.0.0.0/0" >> /etc/sockd.conf && \
    echo "    protocol: tcp udp" >> /etc/sockd.conf && \
    echo "    command: bind connect udpassociate" >> /etc/sockd.conf && \
    echo "    log: error" >> /etc/sockd.conf && \
    echo "}" >> /etc/sockd.conf

EXPOSE 1080

# Start Dante
CMD ["sockd", "-f", "/etc/sockd.conf", "-N"]
