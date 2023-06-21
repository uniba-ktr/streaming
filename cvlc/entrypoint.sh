#!/usr/bin/env bash

function sub_av1() {
  cvlc v4l2:///dev/video0 \
       --sout "#transcode{vcodec=av1,fps=24,width=$width,height=$height,quality=realtime}:udp{dst=$IP,port=$port}"\
       --no-sout-audio
}

function sub_h264() {
  cvlc v4l2:///dev/video0 \
     --sout "#transcode{vcodec=h264,width=$width,height=$height,framerate=20,tune=zerolatency,preset=ultrafast}:udp{dst=$IP:$port}" \
     --no-sout-audio
}

function sub_h265() {
  cvlc v4l2:///dev/video0 \
    --sout "#transcode{vcodec=h265,width=$width,height=$height,framerate=30,tune=zerolatency,preset=ultrafast}:udp{dst=$IP:$port}" \
    --no-sout-audio
}

function sub_vp8() {
  cvlc v4l2:///dev/video0 \
    --sout "#transcode{vcodec=VP80,vb=2000,speed=16,width=$width,height=$height,fps=30,quality=realtime}:std{access=http{mime=video/webm},mux=webm,dst=$IP:$port/webcam.webm}" \
    --no-sout-audio
}

function sub_vp9() {
  cvlc v4l2:///dev/video0 \
    --sout "#transcode{vcodec=VP90,vb=2000,speed=16,width=$width,height=$height,fps=24,quality=realtime}:udp{dst=$IP,port=$port}" \
    --no-sout-audio
}

function sub_mjpeg(){
  cvlc v4l2:///dev/video0 --v4l2-width $width --v4l2-height $height --v4l2-chroma MJPG --sout "#standard{access=udp,mux=ts,dst=$IP:$port}"
}

source /usr/lib/streaming.sh

exit 0
