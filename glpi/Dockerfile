# Start from the official GLPI image
FROM glpi/glpi:latest

# Switch back to root (the official image sets USER www-data)
USER root

# Disable the bundled entrypoint script
ENTRYPOINT []

# Run supervisord directly as root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
