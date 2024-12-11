#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if required environment variables are set
check_env_vars() {
  local required_vars=("LDAP_URL" "LDAP_BIND_DN" "LDAP_BIND_PASSWORD")
  for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
      echo "Error: Environment variable $var is not set."
      exit 1
    fi
  done
}

# Ensure WebDAV directories and permissions are correct
setup_webdav_dirs() {
  echo "Ensuring WebDAV directories and permissions are correct..."
  mkdir -p /var/www/webdav /var/lock/apache2
  chown -R www-data:www-data /var/www/webdav
  chown -R www-data:www-data /var/lock/apache2
  chmod 700 /var/lock/apache2
}

# Create htpasswd file dynamically
setup_htpasswd() {
  echo "Creating htpasswd file..."
  htpasswd -cb /etc/apache2/webdav.htpasswd "${WEBDAV_USER}" "${WEBDAV_PASSWORD}"
  chown www-data:www-data /etc/apache2/webdav.htpasswd
}

# Generate Apache configuration from template
generate_apache_config() {
  echo "Generating Apache configuration from template..."
  envsubst </etc/apache2/sites-available/000-default.conf.template >/etc/apache2/sites-available/000-default.conf
  a2ensite 000-default
}

# Start Apache
start_apache() {
  echo "Starting Apache server..."
  exec apachectl -D FOREGROUND
}

# Main script logic
main() {
  echo "Starting entrypoint script..."

  # Validate environment variables
  echo "Validating environment variables..."
  check_env_vars

  # Ensure WebDAV directories and permissions
  setup_webdav_dirs

  # Setup htpasswd file
  setup_htpasswd

  # Generate Apache configuration
  generate_apache_config

  # Health check
  echo "ok" >/var/www/html/health.txt

  # Start Apache
  start_apache
}

# Execute the main function
main
