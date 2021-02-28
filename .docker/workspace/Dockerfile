ARG TARTET_PHP_VERSION=7.3
FROM php:${TARTET_PHP_VERSION}-cli-alpine

ARG SERVICE_DIR="./workspace"
COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

ARG TZ=UTC
RUN /tmp/scripts/set_timezone.sh ${TZ}

# add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN set -eux && apk --update add --no-cache sudo bash coreutils wget curl ;

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}
RUN /tmp/scripts/install_php_extensions.sh
RUN /tmp/scripts/install_software.sh

# set up bash
RUN apk add --update bash && rm -rf /var/cache/apk/* \ ;


# set up .ssh
RUN apk update -yqq && apk add -yqq openssh-server \
    && mkdir /var/run/sshd \
;
USER ${APP_USER}
COPY ${SERVICE_DIR}/.ssh/insecure_id_rsa.pub /tmp/insecure_id_rsa.pub
RUN mkdir -p ~/.ssh \
 && cat /tmp/insecure_id_rsa.pub >> ~/.ssh/authorized_keys \
 && chown -R ${APP_USER}: ~/.ssh \
 && chmod 700 ~/.ssh \
 && chmod 600 ~/.ssh/authorized_keys \
;

USER root
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

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

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \

USER ${APP_USER}
# nvm environment variables
ENV NVM_DIR /home/${APP_USER}/.nvm
ARG NODE_VERSION=stable

# install nvm
RUN mkdir -p $NVM_DIR \
    && curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && nvm alias ${NODE_VERSION} \ ;


RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;
# Add PATH for node
ENV PATH $PATH:/home/${APP_USER}/.node-bin

USER root

RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="/home/${APP_USER}/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;
# workdir
ARG WORKSPACE_PATH="/var/www/current"
WORKDIR "$WORKSPACE_PATH"

# entrypoint
RUN mkdir -p /bin/docker-entrypoint/ \
 && cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
 && chmod +x -R /bin/docker-entrypoint/ \
;

RUN /tmp/scripts/cleanup.sh

# @see https://docs.docker.com/engine/examples/running_ssh_service/
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh"]

