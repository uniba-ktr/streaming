ARG image=ghcr.io/uniba-ktr/streaming-base

FROM $image

# Install FFmpeg and the necessary libaries:
RUN apt-get update && apt-get install -y \
      ffmpeg \
      libaom-dev &&\
      rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT  ["entrypoint.sh"]
