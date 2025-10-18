FROM ghcr.io/linuxserver/baseimage-kasmvnc:arch-version-2025-07-12

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="[Mollomm1 Mod] Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mollomm1"

# Copy your configuration and scripts
COPY /root/ /
COPY options.json /

# ---- Install packages ----
RUN echo "**** initializing keyring ****" && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    echo "**** refreshing keys ****" && \
    pacman -Sy archlinux-keyring --noconfirm && \
    pacman-key --refresh-keys && \
    echo "**** updating system ****" && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed firefox jq wget && \
    chmod +x /install-de.sh && \
    /install-de.sh

# ---- Install extra apps ----
RUN \
  chmod +x /installapps.sh && \
  /installapps.sh && \
  rm /installapps.sh

# ---- Cleanup ----
RUN \
  echo "**** cleanup ****" && \
  yes | pacman -Scc && \
  rm -rf /config/.cache /var/tmp/* /tmp/*

# ---- Ports & Volumes ----
EXPOSE 3000
VOLUME /config
