FROM alpine:3.6
LABEL maintainer "v.la@live.cn"

ENV SERVICE_NAME=redis \
    SERVICE_USER=redis \
    SERVICE_GROUP=redis \
    SERVICE_UID=1000 \
    SERVICE_GID=1000 \
    SERVICE_CONF=/etc/redis/redis.conf \
    REDIS_VERSION=4.0.1 \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis 

LABEL description="redis built from source" \
      redis="redis ${SERVICE_VERSION}" \
      maintainer="JohnWu <v.la@live.cn>"
      
ARG REDIS_DOWNLOAD_URL=http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz
ARG REDIS_DOWNLOAD_SHA=2049cd6ae9167f258705081a6ef23bb80b7eff9ff3d0d7481e89510f27457591

#china mirrors repos
RUN echo "https://mirrors.ustc.edu.cn/alpine/latest-stable/main" > /etc/apk/repositories \
&&  echo "https://mirrors.ustc.edu.cn/alpine/latest-stable/community" >> /etc/apk/repositories


RUN apk -U upgrade && apk add --update --no-cache bash libressl su-exec curl \
&& apk add --no-cache --virtual .build-deps gcc coreutils linux-headers make musl-dev \
&& wget -cq ${REDIS_DOWNLOAD_URL} -O /tmp/redis-${REDIS_VERSION}.tar.gz \
&& echo "$REDIS_DOWNLOAD_SHA /tmp/redis-${REDIS_VERSION}.tar.gz" | sha256sum -c - \
&& mkdir -p /tmp/redis \
&& tar -zxf /tmp/redis-${REDIS_VERSION}.tar.gz --strip-components=1 -C /tmp/redis \
&& grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /tmp/redis/src/server.h \
&& sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /tmp/redis/src/server.h \
&& grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /tmp/redis/src/server.h \
&& cd  /tmp/redis \
&& make -j $(getconf _NPROCESSORS_ONLN) && make install \
&& mkdir -p /etc/redis/ && cp redis.conf ${SERVICE_CONF} \

&& sed 's/^daemonize yes/daemonize no/' -i ${SERVICE_CONF} \
&& sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i ${SERVICE_CONF} \
&& sed 's/^# unixsocket \/tmp\/redis.sock/unixsocket \/run\/redis\/redis.sock/' -i ${SERVICE_CONF} \
&& sed 's/^# unixsocketperm 700/unixsocketperm 777/' -i ${SERVICE_CONF} \
&& sed '/^logfile/d' -i ${SERVICE_CONF} \

&& addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} \
&& adduser -g "${SERVICE_NAME} user" -D -h ${REDIS_DATA_DIR} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER} \

&& apk del .build-deps \
&& rm -rf \
      /tmp/* \
      /var/cache/apk/*

RUN mkdir -p /run/redis ${REDIS_LOG_DIR} ${REDIS_DATA_DIR} && chmod -R 0755 ${REDIS_LOG_DIR} /run/redis \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${REDIS_DATA_DIR} ${REDIS_LOG_DIR} ${SERVICE_CONF} /run/redis /etc/redis/

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 6379/tcp

VOLUME ["${REDIS_DATA_DIR}"]
WORKDIR ${REDIS_DATA_DIR}

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["redis-server"]
