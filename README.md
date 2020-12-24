
# leejoneshane/nextcloud

專為臺北市教育局校園單一身份驗證設計的 nextcloud，並且解決了官方容器無法重啟的問題！

若要讓系統實際上線服務，請務必修改環境變數，在 docker-compose.yml 檔案中，與網域和密碼相關的所有參數。

## nextcloud-social-login 模組 Tpedu Provider 說明

容器啟動後，請以管理員身份登入（帳號密碼於 docker-compose.yml 中設定）

在管理選單的「應用程式」頁面中，可以發現網站已經自動啟用「社交登入」模組，但在完成設定之前並沒有作用。

從管理選單點選「設定」頁面，找到「管理」設定（在「個人」設定的下方）

輸入您向 ldap.tp.edu.tw 申請的介接專案編號與密鑰，儲存設定後，可以在登入頁面看到多一個「校園單一身份驗證」的按鈕，點此按鈕即可！

如果想要讓登入頁面直接改為 ldap.tp.edu.tw 的登入頁面，請在 /var/www/html/config/config.php 中加入：

    'social_login_auto_redirect' => true

## 追加參數說明

* __ORG: xxps__ 務必修改為貴校在 ldap.tp.edu.tw 上的組織代號。這個參數用來核對登入者隸屬的學校，只有符合的學校師生帳號才能成功登入使用雲端硬碟。

# What is Nextcloud?

A safe home for all your data. Access & share your files, calendars, contacts, mail & more from any device, on your terms.

> [Nextcloud.com](https://nextcloud.com/)

![logo](https://raw.githubusercontent.com/docker-library/docs/eabcf59e64b4395e681a7f7a9773bd213c9f3678/nextcloud/logo.svg?sanitize=true)

## docker-compose.yml 中其他參數說明

The Nextcloud image supports auto configuration via environment variables. You can preconfigure everything that is asked on the install page on first run. To enable auto configuration, set your database connection via the following environment variables. ONLY use one database type!

**SQLite**:

-	`SQLITE_DATABASE` Name of the database using sqlite

**MYSQL/MariaDB**:

-	`MYSQL_DATABASE` Name of the database using mysql / mariadb.
-	`MYSQL_USER` Username for the database using mysql / mariadb.
-	`MYSQL_PASSWORD` Password for the database user using mysql / mariadb.
-	`MYSQL_HOST` Hostname of the database server using mysql / mariadb.

**PostgreSQL**:

-	`POSTGRES_DB` Name of the database using postgres.
-	`POSTGRES_USER` Username for the database using postgres.
-	`POSTGRES_PASSWORD` Password for the database user using postgres.
-	`POSTGRES_HOST` Hostname of the database server using postgres.

If you set any values, they will not be asked in the install page on first run. With a complete configuration by using all variables for your database type, you can additionally configure your Nextcloud instance by setting admin user and password (only works if you set both):

-	`NEXTCLOUD_ADMIN_USER` Name of the Nextcloud admin user.
-	`NEXTCLOUD_ADMIN_PASSWORD` Password for the Nextcloud admin user.

If you want, you can set the data directory, otherwise default value will be used.

-	`NEXTCLOUD_DATA_DIR` (default: `/var/www/html/data`) Configures the data directory where nextcloud stores all files from the users.

One or more trusted domains can be set through environment variable, too. They will be added to the configuration after install.

-	`NEXTCLOUD_TRUSTED_DOMAINS` (not set by default) Optional space-separated list of domains

The install and update script is only triggered when a default command is used (`apache-foreground` or `php-fpm`). If you use a custom command you have to enable the install / update with

-	`NEXTCLOUD_UPDATE` (default: `0`)

If you want to use Redis you have to create a separate [Redis](https://hub.docker.com/_/redis/) container in your setup / in your docker-compose file. To inform Nextcloud about the Redis container, pass in the following parameters:

-	`REDIS_HOST` (not set by default) Name of Redis container
-	`REDIS_HOST_PORT` (default: `6379`) Optional port for Redis, only use for external Redis servers that run on non-standard ports.
-	`REDIS_HOST_PASSWORD` (not set by default) Redis password

The use of Redis is recommended to prevent file locking problems. See the examples for further instructions.

To use an external SMTP server, you have to provide the connection details. To configure Nextcloud to use SMTP add:

-	`SMTP_HOST` (not set by default): The hostname of the SMTP server.
-	`SMTP_SECURE` (empty by default): Set to `ssl` to use SSL, or `tls` to use STARTTLS.
-	`SMTP_PORT` (default: `465` for SSL and `25` for non-secure connections): Optional port for the SMTP connection. Use `587` for an alternative port for STARTTLS.
-	`SMTP_AUTHTYPE` (default: `LOGIN`): The method used for authentication. Use `PLAIN` if no authentication is required.
-	`SMTP_NAME` (empty by default): The username for the authentication.
-	`SMTP_PASSWORD` (empty by default): The password for the authentication.
-	`MAIL_FROM_ADDRESS` (not set by default): Use this address for the 'from' field in the emails sent by Nextcloud.
-	`MAIL_DOMAIN` (not set by default): Set a different domain for the emails than the domain where Nextcloud is installed.

Check the [Nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/email_configuration.html) for other values to configure SMTP.

To use an external S3 compatible object store as primary storage, set the following variables:

-	`OBJECTSTORE_S3_HOST`: The hostname of the object storage server
-	`OBJECTSTORE_S3_BUCKET`: The name of the bucket that Nextcloud should store the data in
-	`OBJECTSTORE_S3_KEY`: AWS style access key
-	`OBJECTSTORE_S3_SECRET`: AWS style secret access key
-	`OBJECTSTORE_S3_PORT`: The port that the object storage server is being served over
-	`OBJECTSTORE_S3_SSL` (default: `true`): Whether or not SSL/TLS should be used to communicate with object storage server
-	`OBJECTSTORE_S3_REGION`: The region that the S3 bucket resides in.
-	`OBJECTSTORE_S3_USEPATH_STYLE` (default: `false`): Not required for AWS S3

Check the [Nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/primary_storage.html#simple-storage-service-s3) for more information.

To use an external OpenStack Swift object store as primary storage, set the following variables:

-	`OBJECTSTORE_SWIFT_URL`: The Swift identity (Keystone) endpoint
-	`OBJECTSTORE_SWIFT_AUTOCREATE` (default: `false`): Whether or not Nextcloud should automatically create the Swift container
-	`OBJECTSTORE_SWIFT_USER_NAME`: Swift username
-	`OBJECTSTORE_SWIFT_USER_PASSWORD`: Swift user password
-	`OBJECTSTORE_SWIFT_USER_DOMAIN` (default: `Default`): Swift user domain
-	`OBJECTSTORE_SWIFT_PROJECT_NAME`: OpenStack project name
-	`OBJECTSTORE_SWIFT_PROJECT_DOMAIN` (default: `Default`): OpenStack project domain
-	`OBJECTSTORE_SWIFT_SERVICE_NAME` (default: `swift`): Swift service name
-	`OBJECTSTORE_SWIFT_SERVICE_REGION`: Swift endpoint region
-	`OBJECTSTORE_SWIFT_CONTAINER_NAME`: Swift container (bucket) that Nextcloud should store the data in

Check the [Nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/primary_storage.html#openstack-swift) for more information.

## Using the apache image behind a reverse proxy and auto configure server host and protocol

The apache image will replace the remote addr (ip address visible to Nextcloud) with the ip address from `X-Real-IP` if the request is coming from a proxy in 10.0.0.0/8, 172.16.0.0/12 or 192.168.0.0/16 by default. If you want Nextcloud to pick up the server host (`HTTP_X_FORWARDED_HOST`), protocol (`HTTP_X_FORWARDED_PROTO`) and client ip (`HTTP_X_FORWARDED_FOR`) from a trusted proxy disable rewrite ip and the reverse proxies ip address to `TRUSTED_PROXIES`.

-	`APACHE_DISABLE_REWRITE_IP` (not set by default): Set to 1 to disable rewrite ip.
-	`TRUSTED_PROXIES` (empty by default): A space-separated list of trusted proxies. CIDR notation is supported for IPv4.

If the `TRUSTED_PROXIES` approach does not work for you, try using fixed values for overwrite parameters.

-	`OVERWRITEHOST` (empty by default): Set the hostname of the proxy. Can also specify a port.
-	`OVERWRITEPROTOCOL` (empty by default): Set the protocol of the proxy, http or https.
-	`OVERWRITEWEBROOT` (empty by default): Set the absolute path of the proxy.
-	`OVERWRITECONDADDR` (empty by default): Regex to overwrite the values dependent on the remote address.

Check the [Nexcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html) for more details.

Keep in mind that once set, removing these environment variables won't remove these values from the configuration file, due to how Nextcloud merges configuration files together.
