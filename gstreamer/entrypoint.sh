#!/usr/bin/env bash
# false=0, true=1
DEBUG=1

width=${width:-640}
height=${height:-480}
IP=${IP:-127.0.0.1}
port=${port:-2000}

ProgName=$(basename $0)

# Debugging, e.g. with sed
(( $DEBUG )) && SED="sed" || SED="sed -i"

function sub_av1() {
  gst-launch-1.0 v4l2src device=/dev/video0 \
 ! video/x-raw,width=$width,height=$height,framerate=24/1 \
 ! av1enc quality=realtime \
 ! rtpav1pay \
 ! udpsink host=$IP port=$port
}

function sub_h264() {
  gst-launch-1.0 -vv -e v4l2src device=/dev/video0 \
    ! "image/jpeg,width=$width,height=$height" \
    ! queue \
    ! jpegdec \
    ! videoconvert \
    ! x264enc \
    ! h264parse \
    ! rtph264pay \
    ! udpsink host=$IP port=$port
}

function sub_h265() {
  gst-launch-1.0 v4l2src device=/dev/video0 \
    ! video/x-raw,width=$width,height=$height,framerate=24/1 \
    ! x265enc tune=zerolatency preset=ultrafast \
    ! rtph264pay \
    ! udpsink host=$IP port=$port
}

function sub_vp8() {
  gst-launch-1.0 v4l2src device=/dev/video0 \
    ! video/x-raw,width=$width,height=$height,framerate=24/1 \
    ! vp8enc quality=realtime
    ! rtpvp8pay \
    ! udpsink host=$IP port=$port
}

function sub_vp9() {
  gst-launch-1.0 v4l2src device=/dev/video0 \
	! video/x-raw,width=$width,height=$height,framerate=24/1 \
	! vp9enc quality=realtime \
	! rtpvp9pay \
	! udpsink host=$IP port=$port
}



sub_help(){
cat << EOM
This script helps to copy itself to a server and execute a secondary function. Needs SSH to be setup to connect to a server.
Usage: $ProgName <subcommand> [required] {optional}
Subcommands
  av1                         With H264 encoding
  h264                        With H264 encoding
  h265                        With H264 encoding
  vp8                         With H264 encoding
  vp9                         With H264 encoding
For help with each subcommand run:
$ProgName <subcommand> -h|--help
EOM
}

subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        echo "Runnig for ${subcommand}, if available"
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac
exit 0
