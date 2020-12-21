FROM nextcloud

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh