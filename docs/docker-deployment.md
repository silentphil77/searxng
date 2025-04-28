# Manual Docker Deployment Guide

This guide explains how to deploy SearXNG using standard Docker and Docker Compose, without Coolify.

## Prerequisites

- Docker and Docker Compose installed on your system
- Basic understanding of Docker containers
- A server or VPS to host the instance

## Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/PhilParkerBrown/searxng.git
cd searxng
```

### 2. Configure Environment Variables

```bash
cp .env.example .env
```

Edit the `.env` file to configure your instance:

```bash
nano .env
```

Key settings to configure:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `BASE_URL` | The public URL of your instance | `https://search.yourdomain.com/` |
| `INSTANCE_NAME` | Name shown on your instance | `My SearXNG` |
| `SEARXNG_REDIS_URL` | Redis connection string | `redis://searxng-redis:6379/0` |
| `SEARXNG_MEILISEARCH_URL` | Meilisearch connection | `http://searxng-meilisearch:7700` |
| `SEARX_SECRET_KEY` | Secret key for secure operations | Generated random hexadecimal string |

### 3. Generate a Secure Secret Key

Use the provided utility to generate a secure key:

```bash
python GenerateHex/app.py
```

Copy the generated key to your `.env` file for the `SEARX_SECRET_KEY` variable.

### 4. Start the Services

```bash
docker-compose up -d
```

### 5. Access Your SearXNG Instance

Navigate to `http://localhost:8083` in your web browser (or the configured BASE_URL if deployed to a server).

## Docker Compose Configuration Options

The `docker-compose.yml` file includes two configuration options:

### Default Configuration

The active, uncommented configuration includes:

- Data persistence for all services
- AOF persistence for Redis
- No custom networking
- Dynamic rate limiting configuration

### Enhanced Configuration (Optional)

An alternative configuration is available with custom networking for better service isolation:

1. Edit the `docker-compose.yml` file
2. Uncomment the network sections for each service
3. Uncomment the networks section at the bottom of the file
4. Restart the services with `docker-compose down && docker-compose up -d`

## Port Configuration

By default, SearXNG is accessible on port 8083. To change this, modify the `ports` section in `docker-compose.yml`:

```yaml
ports:
  - 'your_port:8080'
```

## Maintenance Tasks

### Updating the Instance

```bash
docker-compose pull
docker-compose down
docker-compose up -d
```

### Viewing Logs

```bash
docker-compose logs -f
```

To view logs for a specific service:

```bash
docker-compose logs -f searxng
```

### Backup

The SearXNG data is stored in Docker volumes. Back them up with:

```bash
# Create backup directory if it doesn't exist
mkdir -p backup

# Back up SearXNG configuration
docker run --rm -v searxng-data:/data -v $(pwd)/backup:/backup alpine tar -czf /backup/searxng-data-$(date +%Y%m%d).tar.gz -C /data ./

# Back up Redis data
docker run --rm -v redis-data:/data -v $(pwd)/backup:/backup alpine tar -czf /backup/redis-data-$(date +%Y%m%d).tar.gz -C /data ./

# Back up Meilisearch data
docker run --rm -v meilisearch-data:/data -v $(pwd)/backup:/backup alpine tar -czf /backup/meilisearch-data-$(date +%Y%m%d).tar.gz -C /data ./
```

## Uninstallation

To completely remove SearXNG and all associated Docker resources:

### 1. Stop and Remove Containers

```bash
docker-compose down
```

### 2. Remove Volumes

```bash
docker volume rm searxng-data redis-data meilisearch-data
```

### 3. Remove Images

```bash
docker rmi searxng/searxng:latest redis:alpine getmeili/meilisearch:latest
```

### 4. Remove Network (if using enhanced configuration)

```bash
docker network rm searxng-network
```

### 5. Clean Up Dangling Resources

```bash
docker system prune -af --volumes
```

## Security Considerations

- Always use HTTPS in production environments
- Consider placing a reverse proxy (like Nginx or Traefik) in front of SearXNG
- The built-in rate limiting protects against abuse (60 req/min, 1000 req/hour, 10000 req/day)
- Regularly update your containers with `docker-compose pull`
- Use a strong, randomly generated secret key

## Troubleshooting

### Container Won't Start

Check the logs:

```bash
docker-compose logs searxng
```

### Search Results Not Working

Ensure your instance can connect to the internet. Some search engines may block connections from VPS providers or data centers.

### Performance Issues

- Check Redis connection
- Ensure Meilisearch is running properly
- Consider allocating more resources to containers 