FROM alpine:latest

# Install microsocks and netcat for health endpoint
RUN apk add --no-cache git make gcc musl-dev netcat-openbsd && \
    git clone https://github.com/rofl0r/microsocks && \
    cd microsocks && make && \
    mv microsocks /usr/local/bin/ && \
    cd / && rm -rf microsocks && \
    apk del git make gcc musl-dev

# Railway's PORT variable (for health check)
ENV PORT=8080

# Expose both SOCKS5 port and health check port
EXPOSE 1080 ${PORT}

# Create startup script
RUN printf '#!/bin/sh\n\
# Start simple HTTP health server on Railway PORT\n\
while true; do \n\
  echo -e "HTTP/1.1 200 OK\\r\\n\\r\\nSOCKS5 Running" | nc -l -p ${PORT} -q 1\n\
done &\n\
\n\
# Start microsocks on port 1080\n\
exec microsocks -i 0.0.0.0 -p 1080\n\
' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
