FROM nginx:latest

ARG SERVICE_DIR="./nginx"
COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod 777 -R /tmp/scripts/

ARG TZ=UTC
RUN /tmp/scripts/set_timezone.sh ${TZ}

# add user
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

RUN /tmp/scripts/install_software.sh

COPY ${SERVICE_DIR}/nginx.conf /etc/nginx

ARG APP_USER

RUN /tmp/scripts/modify_config.sh /etc/nginx/nginx.conf \
    "__APP_USER" \
    "${APP_USER}" \
    && /tmp/scripts/modify_config.sh /etc/nginx/nginx.conf \
    "__APP_GROUP" \
    "${APP_GROUP}" \
    ;

COPY ${SERVICE_DIR}/sites-available/* /etc/nginx/sites-available/
ARG WORKSPACE_PATH
RUN /tmp/scripts/modify_config.sh /etc/nginx/sites-available/default.conf \
    "__NGINX_ROOT" \
    "${WORKSPACE_PATH}" \
    ;
# workdir
WORKDIR /etc/nginx/

# cleanup
RUN /tmp/scripts/cleanup.sh

CMD ["nginx"]

EXPOSE 80 443