# SearXNG Docker Setup

[![Version](https://img.shields.io/badge/version-v1.0.0-blue)](https://github.com/PhilParkerBrown/searxng/releases)
[![License](https://img.shields.io/github/license/searxng/searxng)](https://github.com/searxng/searxng/blob/master/LICENSE)
[![Python 3.6+](https://img.shields.io/badge/python-3.6+-green)](https://www.python.org/downloads/)
[![Docker](https://img.shields.io/badge/docker-supported-brightgreen)](https://hub.docker.com/r/searxng/searxng)
[![Coolify Ready](https://img.shields.io/badge/coolify-ready-orange)](https://coolify.io/)

A ready-to-deploy SearXNG instance with Redis caching and Meilisearch integration, optimized for Coolify deployment.

![SearXNG Demo](https://raw.githubusercontent.com/searxng/searxng/master/docs/img/searxng-home.png)

## Overview

This repository provides a containerized SearXNG setup with the following components:

- **SearXNG**: A privacy-respecting metasearch engine
- **Redis**: For caching and improved performance
- **Meilisearch**: For enhanced search capabilities
- **Rate Limiting**: Dynamic configuration that adapts to Coolify's container naming

The configuration is specifically optimized for deployment with [Coolify](https://coolify.io/), a self-hostable Heroku/Netlify alternative.

## Deployment with Coolify

### Prerequisites

- A running Coolify instance
- Basic understanding of Coolify and Docker
- A GitHub account to fork or clone this repository

### Deployment Steps

1. **Fork or Clone Repository**

   Fork this repository to your GitHub account.

2. **Create a New Service in Coolify**

   - In your Coolify dashboard, select "Create new resource" > "Application"
   - Choose "Docker Compose" as the deployment type
   - Connect to your GitHub repository

3. **Configure Environment Variables**

   Navigate to the Environment Variables section in Coolify and set the following variables:

   | Variable | Description | Example Value |
   |----------|-------------|---------------|
   | `BASE_URL` | The public URL of your instance | `https://search.yourdomain.com/` |
   | `INSTANCE_NAME` | Name shown on your instance | `My SearXNG` |
   | `SEARXNG_REDIS_URL` | Redis connection string | `redis://searxng-redis:6379/0` |
   | `SEARXNG_MEILISEARCH_URL` | Meilisearch connection | `http://searxng-meilisearch:7700` |
   | `SEARX_SECRET_KEY` | Secret key for secure operations | Generated random hexadecimal string |

   **Important for Coolify Users**: The `SEARXNG_REDIS_URL` will be automatically used for rate limiting. Our setup adapts to Coolify's dynamic container naming, so you don't need to manually update the configuration after deployment.

   ![Coolify Environment Variables](https://raw.githubusercontent.com/PhilParkerBrown/searxng/main/docs/coolify-env-vars.png)

4. **Generate Secret Key**

   You can generate a secure random key using the included `GenerateHex` utility or any secure random generator:

   ```bash
   python GenerateHex/app.py
   ```

   Paste the generated key as the `SEARX_SECRET_KEY` value.

5. **Deploy the Application**

   Click "Deploy" in the Coolify dashboard to start the deployment process.

6. **Access Your SearXNG Instance**

   Once deployed, your SearXNG instance will be available at the URL you configured in your Coolify settings.

## Maintenance

### Updating the Instance

To update your SearXNG instance:

1. Navigate to your application in the Coolify dashboard
2. Click "Redeploy" to pull the latest images and restart the containers

### Viewing Logs

Access logs directly through the Coolify dashboard:

1. Navigate to your application
2. Click on "Logs" to view real-time container logs

## Uninstallation

To completely remove your SearXNG instance from Coolify:

1. Navigate to your application in the Coolify dashboard
2. Click "Settings" > "Danger Zone" > "Delete resource"
3. Confirm the deletion

### Manual Cleanup (if needed)

If you need to manually clean up any remaining resources on your server after uninstalling from Coolify:

```bash
# Find and remove any remaining containers
docker ps -a | grep -i searxng | awk '{print $1}' | xargs -r docker rm -f

# Remove all volumes related to the application
docker volume ls | grep -i "searxng\|redis-data\|meilisearch-data" | awk '{print $2}' | xargs -r docker volume rm

# Clean up all unused Docker resources
docker system prune -af --volumes
```

## Configuration Options

### Rate Limiting

This setup includes built-in rate limiting to protect your SearXNG instance from abuse:

- **60 requests per minute**
- **1000 requests per hour**
- **10000 requests per day**

The rate limiter automatically connects to Redis using the `SEARXNG_REDIS_URL` environment variable, making it compatible with Coolify's dynamic container naming.

### Custom CSS

This setup includes a custom CSS file that hides the footer by default. You can modify the CSS to further customize your SearXNG instance:

#### Option 1: Edit Before Deployment

1. Edit the `custom.css` file in your repository
2. Add any custom CSS rules you want
3. Rebuild and redeploy your application

#### Option 2: Edit Without Rebuilding (Coolify)

The CSS file is mounted as a volume, allowing you to edit it directly on the server without rebuilding:

1. In Coolify, navigate to your application
2. Use the "Files" tab to edit the `custom.css` file
3. Save your changes and they will immediately apply to your SearXNG instance

Example of customizations you can add to `custom.css`:

```css
/* Change the primary color */
:root {
  --color-primary: #3366cc;
}

/* Customize the header */
.header {
  background-color: #f5f5f5;
}

/* Hide specific elements */
.element-to-hide {
  display: none !important;
}
```

After making changes to `custom.css`, commit them to your repository and redeploy in Coolify.

### Custom SearXNG Settings

For advanced configuration beyond environment variables, you can create a custom settings file and mount it in the docker-compose.yml:

```yaml
volumes:
  - './custom-settings.yml:/etc/searxng/settings.yml'
```

## Troubleshooting

### Application Not Starting

- Check if all required environment variables are correctly set in Coolify
- Verify that Coolify has enough resources to run all three containers
- Check the application logs in the Coolify dashboard

### Search Engines Not Working

- Some search engines may block connections from cloud providers or VPS services
- Check SearXNG logs for connection errors
- Consider enabling fewer search engines in a custom configuration

### Performance Issues

- Verify Redis is functioning correctly
- Ensure Meilisearch has enough resources allocated
- Consider scaling up your Coolify instance resources

## Manual Docker Deployment

For users who prefer manual deployment without Coolify, refer to our [Docker Deployment Guide](docs/docker-deployment.md).

## Project Structure

```
searxng/
├── GenerateHex/        # Utility for generating secure keys
│   ├── app.py          # Key generation script
│   └── README.md       # Utility documentation
├── .env.example        # Example environment configuration
├── docker-compose.yml  # Docker services configuration
└── README.md           # Main project documentation
```

## Built With

- [SearXNG](https://github.com/searxng/searxng) - Privacy-focused metasearch engine
- [Docker](https://www.docker.com/) - Containerization platform
- [Redis](https://redis.io/) - In-memory data structure store for caching
- [Meilisearch](https://www.meilisearch.com/) - Search engine for faster results
- [Coolify](https://coolify.io/) - Self-hosted PaaS platform

## Contributing

Contributions to improve this setup are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This setup is released under the same license as SearXNG. See [SearXNG's license](https://github.com/searxng/searxng/blob/master/LICENSE) for details.

## Author

- [Phil Brown](https://github.com/PhilParkerBrown) - *Initial work*
