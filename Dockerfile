# Base image
FROM docker.io/library/ubuntu:noble

# Install Apache, WebDAV, and related modules
RUN apt-get update -qq && \
    apt-get install -yqq \
        apache2 \
        apache2-bin \
        apache2-utils \
        bash \
        curl \
        gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable necessary Apache modules
RUN a2enmod dav dav_fs authn_file auth_basic authnz_ldap proxy proxy_http

# Create WebDAV directory and set permissions
RUN mkdir -p /var/www/webdav && \
    chown -R www-data:www-data /var/www/webdav

# Ensure /var/lock/apache2 exists and has correct permissions
RUN mkdir -p /var/lock/apache2 && \
    chown -R www-data:www-data /var/lock/apache2 && \
    chmod 700 /var/lock/apache2

# Copy configuration template and entrypoint script into the image
COPY conf/webdav.conf.template /etc/apache2/sites-available/000-default.conf.template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port 80
EXPOSE 80

# Add health check with HTTP Basic Authentication
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD curl -f -u "${WEBDAV_USER}:${WEBDAV_PASSWORD}" http://localhost:80/ || exit 1
