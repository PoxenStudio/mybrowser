# syntax=docker/dockerfile:1

FROM poxenstudio/baseimage-selkies:ubunturesolute

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="PoxenStudio version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="PoxenStudio"
LABEL org.opencontainers.image.title="MyBrowser" \
      org.opencontainers.image.vendor="PoxenStudio" \
      org.opencontainers.image.source="https://github.com/PoxenStudio/mybrowser"

COPY built/poxenstudio-mybrowser-stable_amd64.deb /tmp/mybrowser.deb
COPY images/default_background.png /usr/share/backgrounds/mybrowser.png
COPY webui /usr/share/selkies/mybrowser-webui
COPY webui/icon.png /usr/share/selkies/www/
COPY webui/favicon.ico /usr/share/selkies/www/

# title
ENV TITLE=MyBrowser \
  PIXELFLUX_WAYLAND=true \
  BACKGROUND_PNG=/usr/share/backgrounds/mybrowser.png \
  DASHBOARD=mybrowser-webui

ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV UI_LANG=zh-CN

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  swaybg \
  /tmp/mybrowser.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
  /config/.cache \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /tmp/* && \
  mkdir -p /data/mybrowser && \
  mkdir -p /data/extensions && \
  chmod a+w -R /data/

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
