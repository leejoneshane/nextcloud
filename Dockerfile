FROM nextcloud

ENV ORG meps

ADD docker-entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get -y install sudo mc vim git sed && apt-get clean \
    && git clone https://github.com/zorn-v/nextcloud-social-login /root/sociallogin \
    && sed -ri "/DEFAULT_PROVIDERS.*/a 'Tpedu'," \
           /root/sociallogin/lib/Service/ProviderService.php \
    && sed -ri "/Telegram.*/a 'Hybridauth\\Provider\\Tpedu' => $vendorDir . '/hybridauth/hybridauth/src/Provider/Tpedu.php'," \
           /root/sociallogin/3rdparty/composer/autoload_classmap.php

ADD Tpedu.php /root/sociallogin/3rdparty/hybridauth/hybridauth/src/Provider/Tpedu.php
RUN chmod +x /entrypoint.sh \
    && chown -R www-data:root /root/sociallogin \
    && chmod -R 644 /root/sociallogin
