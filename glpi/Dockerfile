FROM glpi/glpi:11

WORKDIR /var/www/html/glpi

# Install required tools
RUN apt-get update && apt-get install -y curl tar gzip \
    && rm -rf /var/lib/apt/lists/*

# Download and extract plugin
RUN mkdir -p /var/www/html/glpi/plugins/samlsso \
    && curl -L https://github.com/DonutsNL/samlsso/archive/refs/tags/v1.2.5.tar.gz \
       -o /tmp/samlsso.tar.gz \
    && tar -xzf /tmp/samlsso.tar.gz --strip-components=1 -C /var/www/html/glpi/plugins/samlsso \
    && rm /tmp/samlsso.tar.gz

# Fix permissions
RUN chown -R www-data:www-data /var/www/html/glpi/plugins/samlsso
