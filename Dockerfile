FROM alpine:latest

# Build microsocks and add a simple HTTP health server
RUN apk add --no-cache git make gcc musl-dev python3 && \
    git clone https://github.com/rofl0r/microsocks /tmp/microsocks && \
    cd /tmp/microsocks && \
    make && \
    cp microsocks /usr/local/bin/ && \
    cd / && \
    rm -rf /tmp/microsocks && \
    apk del git make gcc musl-dev

# Create health check HTTP server
RUN cat > /health.py <<'EOF'
from http.server import HTTPServer, BaseHTTPRequestHandler
import sys

class HealthCheck(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'SOCKS5 Proxy Running\n')
    
    def log_message(self, format, *args):
        pass  # Suppress logs

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    server = HTTPServer(('0.0.0.0', port), HealthCheck)
    print(f'Health check server running on port {port}')
    server.serve_forever()
EOF

EXPOSE 1080 10000

# Start both SOCKS5 proxy and health check server
CMD sh -c "python3 /health.py 10000 & microsocks -i 0.0.0.0 -p 1080"
