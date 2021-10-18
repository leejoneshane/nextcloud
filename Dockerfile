FROM nextcloud

ENV ORG meps
ENV version v4.8.8

ADD docker-entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get -y install sudo mc sed libmagickcore-6.q16-6-extra && apt-get clean \
    && echo 'memory_limit=-1' > /usr/local/etc/php/conf.d/memory.ini
    && cd /root \
    && curl -OL https://github.com/zorn-v/nextcloud-social-login/releases/download/${version}/release.tar.gz \
    && tar -zxvf release.tar.gz \
    && sed -ri "/DEFAULT_PROVIDERS.*/{n;N;N;N;N;N;N;N;N;N;N;d}" \
           /root/sociallogin/lib/Service/ProviderService.php \
    && sed -ri "/DEFAULT_PROVIDERS.*/a 'Tpedu'," \
           /root/sociallogin/lib/Service/ProviderService.php \
    && sed -i "s/\$provider.'-'/''/g" \
           /root/sociallogin/lib/Service/ProviderService.php \
    && sed -ri "/Telegram.*/a 'Hybridauth\\\\\\\\Provider\\\\\\\\Tpedu' => \$vendorDir . '/hybridauth/hybridauth/src/Provider/Tpedu.php'," \
           /root/sociallogin/3rdparty/composer/autoload_classmap.php \
    && sed -ri "/Telegram.*/a 'Hybridauth\\\\\\\\Provider\\\\\\\\Tpedu' => __DIR__ . '/..' . '/hybridauth/hybridauth/src/Provider/Tpedu.php'," \
           /root/sociallogin/3rdparty/composer/autoload_static.php

ADD Tpedu.php /root/sociallogin/3rdparty/hybridauth/hybridauth/src/Provider/Tpedu.php
RUN chmod +x /entrypoint.sh \
    && chown -R www-data:root /root/sociallogin \
    && chmod -R 644 /root/sociallogin
