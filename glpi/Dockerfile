# Start from the official GLPI image
FROM glpi/glpi:11

# Set working directory to GLPI root
WORKDIR /var/www/html/glpi

# Download and extract the plugin
ADD https://github.com/DonutsNL/samlsso/archive/refs/tags/v1.2.5.tar.gz /tmp/samlsso.tar.gz
RUN tar -xzf /tmp/samlsso.tar.gz -C plugins/ \
    && mv plugins/samlsso-1.2.5 plugins/samlsso \
    && rm /tmp/samlsso.tar.gz

# Ensure correct permissions (important for GLPI to load plugins)
RUN chown -R www-data:www-data plugins/samlsso
