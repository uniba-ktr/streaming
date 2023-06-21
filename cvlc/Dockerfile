FROM ghcr.io/uniba-ktr/streaming-base

# Install VLC and the necessary libaries:
RUN apt-get update && apt-get install -y \
            vlc \
            libavcodec-extra \
            libx264-dev \
            libx265-dev \
            libvpx-dev \
            libaom-dev && \
            rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

RUN useradd -m vlcuser && usermod -aG video vlcuser
USER vlcuser

ENTRYPOINT  ["entrypoint.sh"]
