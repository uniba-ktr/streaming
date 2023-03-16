#!/bin/bash

# This script starts the gstreamer command for H.264.

gst-launch-1.0 v4l2src device=/dev/video0 \
    ! video/x-raw,width=$width,height=$height,framerate=24/1 \
    ! x264enc tune=zerolatency preset=ultrafast \
    ! rtph264pay \
    ! udpsink host=$IP port=2000
