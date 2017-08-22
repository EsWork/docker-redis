#!/bin/sh
set -e

REDIS_PASSWORD=${REDIS_PASSWORD:-}

function log() {
  echo `date` $ME - $@
}


if [ "$1" = 'redis-server' ]; then
log "[ Starting ${SERVICE_NAME}... ]"
chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${REDIS_DATA_DIR} ${REDIS_LOG_DIR} ${SERVICE_CONF}
exec su-exec ${SERVICE_USER}:${SERVICE_GROUP} "$@" ${SERVICE_CONF} \
${REDIS_PASSWORD:+--requirepass $REDIS_PASSWORD}
fi

exec "$@"