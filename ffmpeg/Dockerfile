FROM debian:stable-slim

# Install FFmpeg and the necessary libaries:
RUN apt-get update && apt-get install -y \
      ffmpeg \
      v4l-utils

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT  ["entrypoint.sh"]
