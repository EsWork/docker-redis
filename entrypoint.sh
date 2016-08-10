#!/bin/sh
set -e

REDIS_PASSWORD=${REDIS_PASSWORD:-}

mkdir -p ${REDIS_DATA_DIR}
chmod -R 0755 ${REDIS_DATA_DIR}
chown -R ${REDIS_USER}:${REDIS_USER} ${REDIS_DATA_DIR}

if [ "${1:0:1}" = '-' ]; then
  EXTRA_ARGS="$@"
  set --
fi

if [[ -z ${1} ]]; then
  echo "Starting redis-server..."
  exec su-exec ${REDIS_USER} $(which redis-server) /etc/redis/redis.conf \
  ${REDIS_PASSWORD:+--requirepass $REDIS_PASSWORD} ${EXTRA_ARGS}
else
  exec "$@"
fi
