FROM glpi-project/glpi:11

WORKDIR /var/www/html/glpi

# Download plugin archive
ADD https://github.com/DonutsNL/samlsso/archive/refs/tags/v1.2.5.tar.gz /tmp/samlsso.tar.gz

# Extract safely and rename
RUN mkdir -p /var/www/html/glpi/plugins \
    && tar -xzf /tmp/samlsso.tar.gz -C /var/www/html/glpi/plugins \
    && ls -l /var/www/html/glpi/plugins \
    && mv /var/www/html/glpi/plugins/samlsso-* /var/www/html/glpi/plugins/samlsso \
    && rm /tmp/samlsso.tar.gz

# Fix permissions
RUN chown -R www-data:www-data /var/www/html/glpi/plugins/samlsso
