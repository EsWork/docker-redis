#!/bin/bash
set -e

REDIS_PASSWORD=${REDIS_PASSWORD:-}

mkdir -p ${REDIS_DATA_DIR}
chmod -R 0755 ${REDIS_DATA_DIR}
chown -R ${REDIS_USER}:${REDIS_USER} ${REDIS_DATA_DIR}

if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == redis-server || ${1} == $(which redis-server) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi
echo ${1}
if [[ -z ${1} ]]; then
  echo "Starting redis-server..."
  exec $(which redis-server) /etc/redis/redis.conf \
  ${REDIS_PASSWORD:+--requirepass $REDIS_PASSWORD} ${EXTRA_ARGS}
else
  exec "$@"
fi
