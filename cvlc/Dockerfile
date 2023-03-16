FROM debian:stable-slim

# Install VLC and the necessary libaries:
RUN apt-get update && apt-get install -y \
            vlc \
            v4l-utils \
            libavcodec-extra \
            libx264-dev \
            libx265-dev \
            libvpx-dev \
            libaom-dev

RUN useradd -m vlcuser && usermod -aG video vlcuser

USER vlcuser

# Add the scripts
COPY . .

ENTRYPOINT  ["/bin/bash"]
