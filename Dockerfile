LABEL org.opencontainers.image.authors="kerta1n"

# Stage 1: Build stage
FROM python:3-alpine AS builder

WORKDIR /build

# Clone the repository with minimal history
RUN apk add --no-cache git && \
    # git clone --depth 1 https://github.com/gomarble-ai/facebook-ads-mcp-server.git && \
    git clone --depth 1 https://github.com/kerta1n/facebook-ads-mcp-server.git && \
    cd facebook-ads-mcp-server && \
    # Install dependencies in a way that can be copied to final stage
    pip install --no-cache-dir --target=/build/deps -r requirements.txt


# Stage 2: Runtime stage
FROM python:3-alpine

WORKDIR /app

# Copy only the necessary files from builder
COPY --from=builder /build/facebook-ads-mcp-server /app
COPY --from=builder /build/deps /usr/local/lib/python3.*/site-packages/

# Environment variable for the token (will be overridden by compose)
ENV FB_TOKEN="token-not-initialized!!"
EXPOSE 8695

# Run the server with the token from environment variable
CMD python server.py --fb-token ${FB_TOKEN}
