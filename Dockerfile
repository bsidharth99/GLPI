# GLPI on Apache + PHP 8.2, no bundled demo/data
FROM php:8.2-apache

# Versions
ARG GLPI_VERSION=10.0.13

# Enable Apache modules
RUN a2enmod rewrite headers

# System deps
RUN apt-get update && apt-get install -y \
    libldap2-dev libicu-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libxml2-dev libonig-dev libpq-dev libmariadb-dev-compat libmariadb-dev \
    unzip git curl && \
    rm -rf /var/lib/apt/lists/*

# PHP extensions required by GLPI
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
      gd intl zip opcache mysqli pdo pdo_mysql xml mbstring ldap && \
    docker-php-ext-enable opcache

# Tune PHP for production-ish defaults
COPY php.ini /usr/local/etc/php/conf.d/glpi.ini

# Download GLPI (vanilla, no data)
WORKDIR /var/www/html
RUN curl -fsSL -o glpi.tgz https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz && \
    tar -xzf glpi.tgz && rm glpi.tgz && \
    mv glpi/* . && rmdir glpi

# Permissions (Apache user: www-data)
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Healthcheck: simple PHP file existence
HEALTHCHECK --interval=30s --timeout=10s --retries=5 \
  CMD [ -f /var/www/html/index.php ] || exit 1

# Expose HTTP
EXPOSE 80

# Default command
CMD ["apache2-foreground"]

