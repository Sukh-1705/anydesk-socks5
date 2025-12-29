FROM alpine:latest

# Install build tools and compile microsocks
RUN apk add --no-cache git make gcc musl-dev && \
    git clone https://github.com/rofl0r/microsocks /tmp/microsocks && \
    cd /tmp/microsocks && \
    make && \
    cp microsocks /usr/local/bin/ && \
    cd / && \
    rm -rf /tmp/microsocks && \
    apk del git make gcc musl-dev

EXPOSE 1080

# Run microsocks on port 1080, allow all IPs
CMD ["microsocks", "-i", "0.0.0.0", "-p", "1080"]
