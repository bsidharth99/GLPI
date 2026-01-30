FROM glpi/glpi:latest

# Reset to root
USER root

# Skip the image's entrypoint and run supervisord directly
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
