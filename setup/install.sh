#!/bin/sh
set -e

REDIS_DOWNLOAD_URL=http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz

RUNTIME_DEPENDENCIES=""
BUILD_DEPENDENCIES="gcc linux-headers make musl-dev"

download_and_extract() {
  local src=${1}
  local dest=${2}
  local tarball=$(basename ${src})

  if [ ! -f ${REDIS_SETUP_DIR}/src/${tarball} ]; then
    echo "Downloading ${tarball}..."
    mkdir -p ${REDIS_SETUP_DIR}/src/
    wget -cq ${src} -O ${REDIS_SETUP_DIR}/src/${tarball}
  fi

  echo "Extracting ${tarball}..."
  mkdir -p ${dest}
  tar -zxf ${REDIS_SETUP_DIR}/src/${tarball} --strip=1 -C ${dest}
  rm -rf ${REDIS_SETUP_DIR}/src/${tarball}
}

apk add --no-cache ${RUNTIME_DEPENDENCIES} ${BUILD_DEPENDENCIES}

addgroup -S redis && adduser -S -G ${REDIS_USER} ${REDIS_USER}
apk add --no-cache 'su-exec>=0.2'

download_and_extract "${REDIS_DOWNLOAD_URL}" "${REDIS_SETUP_DIR}/redis"
cd ${REDIS_SETUP_DIR}/redis

make -j$(nproc) && make install

sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf
sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf
sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf
sed 's/^# unixsocketperm 700/unixsocketperm 777/' -i /etc/redis/redis.conf
sed '/^logfile/d' -i /etc/redis/redis.conf

mkdir -p /run/redis
chmod -R 0755 /run/redis
chown -R ${REDIS_USER}:${REDIS_USER} /run/redis

mkdir -p ${REDIS_LOG_DIR}
chmod -R 0755 ${REDIS_LOG_DIR}
chown -R ${REDIS_USER}:${REDIS_USER} ${REDIS_LOG_DIR}

apk del ${BUILD_DEPENDENCIES}
rm -rf ${REDIS_SETUP_DIR}/