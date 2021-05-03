FROM nextcloud

ENV ORG meps
ENV version v4.5.0

ADD docker-entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get -y install sudo mc sed gzip && apt-get clean \
    && cd /root \
    && curl -O https://github.com/zorn-v/nextcloud-social-login/releases/download/$version/release.tar.gz \
    && tar zxvf release.tar.gz \ 
    && sed -ri "/DEFAULT_PROVIDERS.*/a 'Tpedu'," \
           /root/sociallogin/lib/Service/ProviderService.php \
    && sed -ri "/Telegram.*/a 'Hybridauth\\\\\\\\Provider\\\\\\\\Tpedu' => $vendorDir . '/hybridauth/hybridauth/src/Provider/Tpedu.php'," \
           /root/sociallogin/3rdparty/composer/autoload_classmap.php

ADD Tpedu.php /root/sociallogin/3rdparty/hybridauth/hybridauth/src/Provider/Tpedu.php
RUN chmod +x /entrypoint.sh \
    && chown -R www-data:root /root/sociallogin \
    && chmod -R 644 /root/sociallogin
