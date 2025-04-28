#!/bin/bash
set -e

# Get the Redis URL from environment variable
REDIS_URL=${SEARXNG_REDIS_URL:-"redis://searxng-redis:6379/0"}

# Create limiter.toml from template
sed "s|REDIS_URL_PLACEHOLDER|$REDIS_URL|g" /etc/searxng/limiter.toml.template > /etc/searxng/limiter.toml

# Continue with the original command
exec "$@" 