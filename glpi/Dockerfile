FROM glpi/glpi:11

WORKDIR /var/www/html/glpi

# Download plugin archive
ADD https://github.com/DonutsNL/samlsso/archive/refs/tags/v1.2.5.tar.gz /tmp/samlsso.tar.gz

# Extract directly into plugins/samlsso
RUN mkdir -p /var/www/html/glpi/plugins/samlsso \
    && tar -xzf /tmp/samlsso.tar.gz --strip-components=1 -C /var/www/html/glpi/plugins/samlsso \
    && rm /tmp/samlsso.tar.gz

# Fix permissions
RUN chown -R www-data:www-data /var/www/html/glpi/plugins/samlsso

