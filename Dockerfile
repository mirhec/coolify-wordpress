FROM wordpress:latest

COPY custom.htaccess /var/www/html/.htaccess
RUN chown www-data:www-data /var/www/html/.htaccess
