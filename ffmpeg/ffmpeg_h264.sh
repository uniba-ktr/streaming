#!/bin/bash

# This script starts the ffmpeg command for H.264.

ffmpeg -f v4l2 \
	-i /dev/video0 \
	-fps 24 \
	-vcodec libx264 \
	-s $width"x"$height \
	-preset ultrafast \
	-tune zerolatency \
	-f mpegts udp://$IP:2000?pkt_size=1316
