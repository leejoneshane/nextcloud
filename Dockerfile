FROM nextcloud

COPY docker-entrypoint.sh /entrypoint.sh
ADD sociallogin /root/
RUN chmod +x /entrypoint.sh \
    && cp -R /root/sociallogin /var/www/html/custom_apps \
    && chown -R www-data:root /var/www/html/custom_apps/sociallogin \
    && chmod -R 755 /var/www/html/custom_apps/sociallogin