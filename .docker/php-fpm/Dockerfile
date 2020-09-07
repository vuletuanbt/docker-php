ARG TARGET_PHP_VERSION=7.3
FROM php:${TARGET_PHP_VERSION}-fpm

ARG SERVICE_DIR="./php-fpm"
COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

ARG TZ=UTC
RUN /tmp/scripts/set_timezone.sh ${TZ}

ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}
RUN /tmp/scripts/install_php_extensions.sh
RUN /tmp/scripts/install_software.sh

# php config
COPY ./.shared/config/php/conf.d/* /usr/local/etc/php/conf.d/

COPY ${SERVICE_DIR}/php-fpm.d/* /usr/local/etc/php-fpm.d
RUN /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/zz-app.conf \
    "__APP_USER" \
    "${APP_USER}" \
    && /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/zz-app.conf \
    "__APP_GROUP" \
    "${APP_GROUP}" \
    ;

# set up xdebug
RUN echo "xdebug.remote_connect_back=0" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.remote_host=host.docker.internal" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.remote_port=9000" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.idekey=PHPSTORM" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.remote_autostart=1" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.cli_color=1" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.profiler_enable=1" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.profiler_output_dir=\"/var/www/current/profiling\"" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.remote_enable=1" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.remote_log=\"/var/www/current/xdebug.log\"" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.var_display_max_children=-1" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \
    && echo "xdebug.var_display_max_depth=-1" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null \;

ARG APP_CODE_PATH="/var/www/current"
WORKDIR "$APP_CODE_PATH}"

RUN mkdir -p /bin/docker-entrypoint/ \
    && cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
    && chmod +x -R /bin/docker-entrypoint/ \
    ;

RUN /tmp/scripts/cleanup.sh
ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh", "php-fpm"]
EXPOSE 9000
