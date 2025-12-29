FROM alpine:latest
RUN apk add --no-cache git make gcc musl-dev && \
    git clone https://github.com/rofl0r/microsocks && \
    cd microsocks && make && \
    mv microsocks /usr/local/bin/ && \
    cd / && rm -rf microsocks && \
    apk del git make gcc musl-dev
EXPOSE 1080
CMD ["microsocks", "-i", "0.0.0.0", "-p", "1080"]
