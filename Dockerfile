# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="PoxenStudio version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="poxenstudio"

COPY built/mybrowser-beta_amd64.deb /tmp/mybrowser.deb

# title
ENV TITLE=MyBrowser \
  PIXELFLUX_WAYLAND=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
  /usr/share/selkies/www/icon.png \
  https://raw.githubusercontent.com/PoxenStudio/mybrowser/main/doc/mybrowser-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  /tmp/mybrowser.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
  /config/.cache \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
