FROM python:3-alpine
LABEL org.opencontainers.image.authors="kerta1n"

WORKDIR /app

# Clone the repository with minimal history
RUN apk add --no-cache git && \
    # git clone --depth 1 https://github.com/gomarble-ai/facebook-ads-mcp-server.git && \
    git clone --depth 1 https://github.com/kerta1n/facebook-ads-mcp-server.git /tmp/repo && \
    mv /tmp/repo/* . && \
    rm -rf /tmp/repo && \
    pip install --no-cache-dir -r requirements.txt

# Environment variable for the token (will be overridden by compose)
ENV FB_TOKEN="token-not-initialized!!"
EXPOSE 8695

# Run the server with the token from environment variable
CMD set -e && python -u server.py --fb-token ${FB_TOKEN}
