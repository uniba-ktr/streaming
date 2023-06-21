#!/usr/bin/env bash

function sub_av1() {
  ffmpeg -f v4l2 \
	-i $video_dev \
	-strict -2 \
	-s $width"x"$height \
	-vcodec libaom-av1 \
	-f http http://$IP_local:$port/webcam.webm
}

function sub_h264() {
  ffmpeg -f v4l2 \
	-i $video_dev \
	-framerate $framerate \
	-vcodec libx264 \
	-s $width"x"$height \
	-preset ultrafast \
	-tune zerolatency \
	-f mpegts udp://$IP:$port

}

function sub_h265() {
  ffmpeg -f v4l2 \
	-i $video_dev \
	-framerate $framerate \
	-s $width"x"$height \
	-vcodec libx265 \
	-preset ultrafast \
	-tune zerolatency \
	-f mpegts udp://$IP:$port

}

function sub_vp8() {
  ffmpeg -f v4l2 \
    -i $video_dev \
    -framerate $framerate \
    -vcodec libvpx \
    -s $width"x"$height \
    -deadline realtime \
    -quality realtime \
    -f rtp rtp://$IP:$port/webcam.webm
}

function sub_vp9() {
  ffmpeg -f v4l2 \
    -i $video_dev \
    -framerate $framerate \
    -s $width"x"$height \
    -strict experimental \
    -vcodec libvpx-vp9 \
    -deadline realtime \
    -quality realtime \
    -f rtp rtp://$IP:$port/webcam.webm
}

function sub_mjpeg() {
  ffmpeg -f v4l2 -input_format yuyv422 -s ${width}"x"${height} -an -i $video_dev -vcodec mjpeg -q:v 2 -f mjpeg udp://$IP:$port
}

source /usr/lib/streaming.sh

exit 0
