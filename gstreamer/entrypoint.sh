#!/usr/bin/env bash
function sub_av1() {
  gst-launch-1.0 v4l2src device=$video_dev \
  ! video/x-raw,width=$width,height=$height,framerate=$framerate/1 \
  ! videoconvert \
  ! video/x-raw, format=I420 \
  ! av1enc \
  ! rtpav1pay pt=96 \
  ! rtpsink host=$IP port=$port
}

function sub_h264() {
  gst-launch-1.0 v4l2src device=$video_dev do-timestamp=true \
    ! video/x-raw, format=YUY2, width=$width, height=$height, framerate=$framerate/1 \
    ! videoconvert \
    ! video/x-raw, format=I420 \
    ! x264enc tune=zerolatency \
    ! rtph264pay config-interval=3 pt=96 \
    ! udpsink host=$IP port=$port
}

function sub_h265() {
  gst-launch-1.0 -v -e v4l2src device=$video_dev do-timestamp=true \
    ! video/x-raw, format=YUY2, width=$width, height=$height, framerate=$framerate/1 \
    ! videoconvert \
    ! video/x-raw, format=I420 \
    ! x265enc tune=zerolatency \
    ! rtph265pay config-interval=3 pt=96 \
    ! udpsink host=$IP port=$port
}

function sub_vp8() {
  gst-launch-1.0 -v -e v4l2src device=$video_dev do-timestamp=true \
    ! video/x-raw, format=YUY2, width=$width, height=$height, framerate=$framerate/1 \
    ! videoconvert \
    ! video/x-raw, format=I420 \
    ! vp8enc \
    ! rtpvp8pay pt=96 \
    ! udpsink host=$IP port=$port
}

function sub_vp9() {
  gst-launch-1.0 -v -e v4l2src device=$video_dev do-timestamp=true \
    ! video/x-raw, format=YUY2, width=$width, height=$height, framerate=$framerate/1 \
    ! videoconvert \
    ! video/x-raw, format=I420 \
    ! vp9enc \
    ! rtpvp9pay pt=96 \
    ! udpsink host=$IP port=$port
}

function sub_mjpeg() {
  gst-launch-1.0 v4l2src device=$video_dev \
    ! image/jpeg,width=$width,height=$height, framerate=$framerate/1 \
    ! rtpjpegpay pt=96 \
    ! udpsink host=$IP port=$port
}

source /usr/lib/streaming.sh

exit 0
