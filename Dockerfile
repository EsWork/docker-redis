FROM alpine:3.4
MAINTAINER JohnWu "v.la@live.cn"

ENV REDIS_VERSION=3.2.3 \
    REDIS_USER=redis \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis \
    REDIS_SETUP_DIR=/usr/src/redis


COPY setup/ ${REDIS_SETUP_DIR}/
RUN bash ${REDIS_SETUP_DIR}/install.sh

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 6379/tcp

VOLUME ["${REDIS_DATA_DIR}"]
WORKDIR ["${REDIS_DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]