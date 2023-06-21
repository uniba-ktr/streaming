#!/usr/bin/env bash
# false=0, true=1
DEBUG=${DEBUG:-1}

width=${width:-640}
height=${height:-480}
IP=${IP:-127.0.0.1}
port=${port:-2000}

ProgName=$(basename $0)

# Debugging, e.g. with sed
(( $DEBUG )) && SED="sed" || SED="sed -i"

function print_config() {
cat << EOM
------------CONFIGURATION------------
Debugging: ${DEBUG}
IP: ${IP}
Port: ${port}
Resolution (WxH): ${width}x${height}
-------------------------------------
EOM
}

function sub_av1() {
  ffmpeg -f v4l2 \
	i /dev/video0 \
	-s $width"x"$height \
	-vcodec libaom-av1 \
	-tune zerolatency \
	-f mpegts udp://$IP:$port?pkt_size=1316
}

function sub_h264() {
  ffmpeg -fflags nobuffer \
        -f v4l2 \
	-framerate 30 \
	-i /dev/video0 \
	-vcodec libx264 \
	-s $width"x"$height \
	-preset ultrafast \
	-tune zerolatency \
	-f mpegts udp://$IP:$port?pkt_size=1316
}

function sub_h265() {
  ffmpeg -f v4l2 \
	  -i /dev/video0 \
	  -framerate 30 \
	  -s $width"x"$height \
	  -vcodec libx265 \
	  -preset ultrafast \
	  -tune zerolatency \
	  -f mpegts udp://$IP:$port
}

function sub_vp8() {
  ffmpeg -f v4l2 \
    -i /dev/video0 \
    -framerate 30 \
    -vcodec libvpx \
    -s $width"x"$height \
    -deadline realtime \
    -quality realtime \
    -f mpegts http://$IP:$port/webcam.webm
}

function sub_vp9() {
  ffmpeg -f v4l2 \
    -i /dev/video0 \
    -s $width"x"$height \
    -vcodec libvpx-vp9 \
    -deadline realtime \
    -quality realtime \
    -f mpegts udp://$IP:$port?pkt_size=1316
}

function sub_mjpeg() {
  ffmpeg -f v4l2 \
    -input_format yuyv422 \
    -s ${width}"x"${height} \
    -an \
    -i /dev/video0 \
    -vcodec mjpeg \
    -q:v 2 \
    -f mjpeg udp://$IP:$port
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
        (( $DEBUG )) && print_config
        shift
        echo "Runnig for ${subcommand}, if available"
        sub_${subcommand} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac
exit 0
