[![Build Status](https://travis-ci.org/vla/docker-redis.svg?branch=master)](https://travis-ci.org/vla/docker-redis)

# Supported tags and respective `Dockerfile` links

- [`latest` , `3.2.2`  (3.2.2/Dockerfile)](https://github.com/vla/docker-redis/blob/master/Dockerfile)

# Introduction

Redis-3.2.2

# Getting started

## Installation

自动化构建镜像的可用[Dockerhub](https://hub.docker.com/r/johnwu/redis)和推荐的安装方法

```bash
docker pull johnwu/redis:latest
```

或者你可以自己构建镜像

```bash
docker build -t johnwu/redis github.com/johnwu/docker-redis
```

## Quickstart

运行Redis：

```bash
docker run --name redis -d \
  -p 6379:6379 --restart=always \
  -v /srv/docker/redis:/var/lib/redis \
  johnwu/redis
```

或者您可以使用示例[docker-compose.yml](docker-compose.yml)文件启动容器


## Logs

使用`--logfile`记录日志

```bash
docker run --name redis -d --restart=always \
  --p 6379:6379 \
  --v /srv/docker/redis:/var/lib/redis \
  johnwu/redis:latest --logfile /var/log/redis/redis-server.log
```
访问redis日志位于`/var/log/redis/redis-server.log`
```bash
docker exec -it redis tail -f /var/log/redis/redis-server.log
```
