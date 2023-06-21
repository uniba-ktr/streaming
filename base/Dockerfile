FROM debian:stable-slim

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y iproute2 v4l-utils && \
    rm -rf /var/lib/apt/lists/*

COPY streaming.sh /usr/lib/streaming.sh
