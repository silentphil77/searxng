#!/bin/bash

echo "Setting up SearXNG with hostname: searxng.111122112.com"
echo "Using IP: 10.1.0.3 and port: 8083"

# Check if .env file exists, create if not
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cat > .env << EOF
# SearXNG Configuration
BASE_URL=https://searxng.111122112.com/
INSTANCE_NAME=SearXNG
SEARXNG_REDIS_URL=redis://searxng-redis:6379/0
SEARXNG_MEILISEARCH_URL=http://searxng-meilisearch:7700
EOF

    # Generate a random secret key
    if command -v python3 &> /dev/null; then
        echo "Generating a secure secret key..."
        SECRET_KEY=$(python3 GenerateHex/app.py | grep "Generated HEX:" | cut -d ":" -f2 | tr -d ' ')
        echo "SEARX_SECRET_KEY=$SECRET_KEY" >> .env
    else
        echo "Python not found. Please run 'python GenerateHex/app.py' and add the generated key to .env file."
        echo "SEARX_SECRET_KEY=generate_a_random_key_here" >> .env
    fi
    
    echo ".env file created."
else
    echo ".env file already exists."
fi

# Build and start the services
echo "Building and starting SearXNG services..."
docker-compose up -d

echo "Setup complete!"
echo "SearXNG should be accessible at: http://10.1.0.3:8083"
echo "or via hostname: https://searxng.111122112.com" 