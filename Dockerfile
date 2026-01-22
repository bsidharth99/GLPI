# Base image: Apache + PHP
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libwebp-dev libzip-dev libldap2-dev libicu-dev \
    mariadb-client unzip curl git \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Configure PHP extensions required by GLPI
RUN docker-php-ext-configure gd --with-jpeg --with-webp \
 && docker-php-ext-install gd mysqli intl zip ldap

# Set working directory
WORKDIR /var/www/html

# Download latest GLPI release (adjust version if needed)
# Check https://github.com/glpi-project/glpi/releases for the newest version
ENV GLPI_VERSION=10.0.12
RUN curl -L https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz -o glpi.tgz \
 && tar xzf glpi.tgz --strip-components=1 \
 && rm glpi.tgz \
 && chown -R www-data:www-data /var/www/html

# Configure Apache document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# Expose HTTP port
EXPOSE 80

# Default command
CMD ["apache2-foreground"]


