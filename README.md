[![Build Status](https://travis-ci.org/EsWork/docker-redis.svg?branch=master)](https://travis-ci.org/EsWork/docker-redis) 
[![](https://images.microbadger.com/badges/image/eswork/redis.svg)](https://microbadger.com/images/eswork/redis "Get your own image badge on microbadger.com")

## Supported tags and respective `Dockerfile` links

- [`latest` , `3.2.8`  (3.2.8/Dockerfile)](https://github.com/vla/docker-redis/blob/master/Dockerfile)

Introduction
---

基于`Alpine linux`镜像构建`Redis-3.2.8`

Getting started

Installation
---

自动化构建镜像的可用[Dockerhub](https://hub.docker.com/r/eswork/redis)和推荐的安装方法

```bash
docker pull eswork/redis:latest
```

或者你可以自己构建镜像

```bash
docker build -t eswork/redis github.com/vla/docker-redis
```

Quickstart
---

运行Redis：

```bash
docker run --name redis -d \
  -p 6379:6379 --restart=always \
  -v /srv/docker/redis:/var/lib/redis \
  eswork/redis
```

或者您可以使用示例[docker-compose.yml](docker-compose.yml)文件启动容器

Logs
---

使用`--logfile`记录日志

```bash
docker run --name redis -d --restart=always \
  -p 6379:6379 \
  -v /srv/docker/redis:/var/lib/redis \
  eswork/redis:latest --logfile /var/log/redis/redis-server.log
```
访问redis日志位于`/var/log/redis/redis-server.log`
```bash
docker exec -it redis tail -f /var/log/redis/redis-server.log
```
