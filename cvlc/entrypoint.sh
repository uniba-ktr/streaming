#!/usr/bin/env bash

function sub_av1() {
  cvlc v4l2://$video_dev \
   --sout-avcodec-strict -2 \
   --sout "#transcode{vcodec=av01,width=$width,height=$height,quality=realtime}:std{access=http{mime=video/webm},mux=webm,dst=$IP_local:$port/webcam.webm}" \
   --no-sout-audio
}

function sub_h264() {
  cvlc v4l2://$video_dev \
     --sout "#transcode{vcodec=h264,width=$width,height=$height,framerate=$framerate,tune=zerolatency,preset=ultrafast}:udp{dst=$IP:$port}" \
     --no-sout-audio
}

function sub_h265() {
  cvlc v4l2://$video_dev \
    --sout "#transcode{vcodec=h265,width=$width,height=$height,framerate=$framerate,tune=zerolatency,preset=ultrafast}:udp{dst=$IP:$port}" \
    --no-sout-audio
}

function sub_vp8() {
  cvlc v4l2://$video_dev \
    --sout "#transcode{vcodec=VP80,vb=2000,speed=16,width=$width,height=$height,fps=$framerate,quality=realtime}:std{access=http{mime=video/webm},mux=webm,dst=$IP_local:$port/webcam.webm}" \
    --no-sout-audio
}

function sub_vp9() {
  cvlc v4l2://$video_dev \
    --sout "#transcode{vcodec=VP90,vb=2000,speed=16,width=$width,height=$height,fps=$framerate,quality=realtime}:std{access=http{mime=video/webm},mux=webm,dst=$IP_local:$port/webcam.webm}" \
    --no-sout-audio
}

function sub_mjpeg(){
  cvlc v4l2://$video_dev --v4l2-width $width --v4l2-height $height --v4l2-chroma MJPG --sout "#standard{access=udp,mux=ts,dst=$IP:$port}"
}

source /usr/lib/streaming.sh

exit 0
