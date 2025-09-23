FROM wordpress:latest

# Environment variables for upload size configuration
ENV UPLOAD_MAX_FILESIZE=512M
ENV POST_MAX_SIZE=512M
ENV MAX_EXECUTION_TIME=300
ENV MAX_INPUT_TIME=300
ENV MEMORY_LIMIT=512M

# Create custom PHP configuration
RUN echo "upload_max_filesize = \${UPLOAD_MAX_FILESIZE}" > /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size = \${POST_MAX_SIZE}" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "max_execution_time = \${MAX_EXECUTION_TIME}" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "max_input_time = \${MAX_INPUT_TIME}" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "memory_limit = \${MEMORY_LIMIT}" >> /usr/local/etc/php/conf.d/uploads.ini

COPY custom.htaccess /var/www/html/.htaccess
RUN chown www-data:www-data /var/www/html/.htaccess

# Create a script to substitute environment variables in PHP config at runtime
RUN echo '#!/bin/bash' > /usr/local/bin/configure-php.sh && \
    echo 'envsubst < /usr/local/etc/php/conf.d/uploads.ini > /tmp/uploads.ini.tmp && mv /tmp/uploads.ini.tmp /usr/local/etc/php/conf.d/uploads.ini' >> /usr/local/bin/configure-php.sh && \
    chmod +x /usr/local/bin/configure-php.sh

# Create a custom entrypoint that configures PHP before starting Apache
RUN echo '#!/bin/bash' > /docker-entrypoint-custom.sh && \
    echo '/usr/local/bin/configure-php.sh' >> /docker-entrypoint-custom.sh && \
    echo 'exec docker-entrypoint.sh "$@"' >> /docker-entrypoint-custom.sh && \
    chmod +x /docker-entrypoint-custom.sh

ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["apache2-foreground"]
