#!/bin/bash
set -e

echo "🔍 SearXNG with Rate Limiting - Setup Script"
echo "============================================"
echo

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

# Generate a secure key for SearXNG
generate_key() {
    if command -v python3 &> /dev/null; then
        SECURE_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
    else
        SECURE_KEY=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 64 | head -n 1)
    fi
    echo $SECURE_KEY
}

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    
    # Set default values
    BASE_URL="http://localhost:8083/"
    INSTANCE_NAME="MySearXNG"
    SEARXNG_REDIS_URL="redis://searxng-redis:6379/0"
    SEARXNG_MEILISEARCH_URL="http://searxng-meilisearch:7700"
    SEARX_SECRET_KEY=$(generate_key)
    
    # Write to .env file
    cat > .env << EOF
BASE_URL=${BASE_URL}
INSTANCE_NAME=${INSTANCE_NAME}
SEARXNG_REDIS_URL=${SEARXNG_REDIS_URL}
SEARXNG_MEILISEARCH_URL=${SEARXNG_MEILISEARCH_URL}
SEARX_SECRET_KEY=${SEARX_SECRET_KEY}
EOF
    
    echo "✅ .env file created successfully"
else
    echo "📋 .env file already exists"
fi

# Build and start containers
echo "🚀 Building SearXNG with rate limiting..."
if command -v docker compose &> /dev/null; then
    docker compose build --no-cache
    echo "🚀 Starting services..."
    docker compose up -d
elif command -v docker-compose &> /dev/null; then
    docker-compose build --no-cache
    echo "🚀 Starting services..."
    docker-compose up -d
else
    echo "❌ Neither 'docker compose' nor 'docker-compose' commands were found. Aborting."
    exit 1
fi

echo
echo "✅ SearXNG with rate limiting is now running!"
echo "📊 Access your SearXNG instance at: http://localhost:8083"
echo
echo "📝 Rate limiting is configured at:"
echo "  - 60 requests per minute"
echo "  - 1000 requests per hour"
echo "  - 10000 requests per day"
echo
echo "🔧 For Coolify deployments, the rate limiter will automatically adapt to Coolify's container naming."
echo 