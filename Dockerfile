FROM searxng/searxng:latest

# Create a template limiter.toml file
COPY limiter.toml.template /etc/searxng/limiter.toml.template

# Add custom settings to enable custom CSS
COPY settings.yml /etc/searxng/settings.yml

# Add custom CSS file
COPY custom.css /usr/local/searxng/searx/static/themes/simple/css/custom.css

# Add an entrypoint script to dynamically update the limiter.toml file
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use our custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/sbin/tini", "--", "/usr/local/searxng/dockerfiles/docker-entrypoint.sh"] 