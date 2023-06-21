ARG image=ghcr.io/uniba-ktr/streaming-base

FROM $image

RUN apt-get update && apt-get install -y \
    	libgstreamer1.0-0 \
	    gstreamer1.0-plugins-base \
	    gstreamer1.0-plugins-good \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-ugly \
	    gstreamer1.0-libav \
	    gstreamer1.0-tools \
	    gstreamer1.0-alsa \
	    gstreamer1.0-pulseaudio && \
      rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT  ["entrypoint.sh"]
