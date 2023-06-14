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
  cvlc v4l2:///dev/video0 \
       --sout "#transcode{vcodec=av1,fps=24,width=$width,height=$height,quality=realtime}:udp{dst=$IP,port=$port}"\
       --no-sout-audio
}

function sub_h264() {
  cvlc v4l2:///dev/video0 \
       --sout "#transcode{vcodec=h264,width=$width,height=$height,fps=24,tune=zerolatency,preset=ultrafast}:udp{dst=$IP,port=$port}" \
       --no-sout-audio
}

function sub_h265() {
  cvlc v4l2:///dev/video0 \
    --sout "#transcode{vcodec=h265,width=$width,height=$height,fps=24,tune=zerolatency,preset=ultrafast}:udp{dst=$IP,port=$port}" \
    --no-sout-audio
}

function sub_vp8() {
  cvlc v4l2:///dev/video0 \
    --sout "#transcode{vcodec=VP80,vb=2000,speed=16,width=$width,height=$height,fps=24,quality=realtime}:udp{dst=$IP,port=$port}" \
    --no-sout-audio
}

function sub_vp9() {
  cvlc v4l2:///dev/video0 \
    --sout "#transcode{vcodec=VP90,vb=2000,speed=16,width=$width,height=$height,fps=24,quality=realtime}:udp{dst=$IP,port=$port}" \
    --no-sout-audio
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
