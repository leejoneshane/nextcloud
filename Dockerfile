FROM nextcloud

ENV ORG meps

ADD docker-entrypoint.sh /entrypoint.sh
ADD sociallogin /root/sociallogin
RUN chmod +x /entrypoint.sh \
    && chown -R www-data:root /root/sociallogin \
    && chmod -R 644 /root/sociallogin \
    && apt-get update && apt-get -y install sudo mc vim && apt-get clean
