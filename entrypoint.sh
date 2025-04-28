#!/bin/sh

# Set hostname in environment if not already set
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME="searxng.111122112.com"
fi

# Generate limiter.toml from template
echo "Configuring rate limiter..."
if [ -f /etc/searxng/limiter.toml.template ]; then
    # Replace placeholder with actual Redis URL
    sed "s|REDIS_URL_PLACEHOLDER|${SEARXNG_REDIS_URL}|g" /etc/searxng/limiter.toml.template > /etc/searxng/limiter.toml
    echo "Rate limiter configured with Redis URL: ${SEARXNG_REDIS_URL}"
else
    echo "Warning: limiter.toml.template not found!"
fi

echo "Starting SearXNG on http://10.1.0.3:8083 (hostname: ${HOSTNAME})"

# Execute the original entrypoint with all arguments
exec "$@" 