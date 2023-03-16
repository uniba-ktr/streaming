#!/bin/bash

# This script starts the cvlc command for H.264.

cvlc v4l2:///dev/video0 \
     --sout "#transcode{vcodec=h264,width=$width,height=$height,fps=24,tune=zerolatency,preset=ultrafast}:udp{dst=$IP:2000}" \
     --no-sout-audio
