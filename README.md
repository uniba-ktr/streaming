# Streaming
Containerized video streaming services based on different frameworks.

All Frameworks (`ffmpeg`, `gstreamer`, and `cvlc`) are available as a containerized service and offer the following codecs:

- `h264`
- `h265`
- `vp8`
- `vp9`
- `mjpeg`

They can be started with
```
docker compose run {framework} {codec}
```

Additional configuration can be done via the following environment variables, which are stored in `configuration.env`:
- `DEBUG`, if unset 1 for true
- `width`, if unset 640
- `height`, if unset 480
- `IP`, address of the interface, the video stream should go to, if unset 127.0.0.1
- `port`, if unset 2000. Please open any other port on the container if needed.
- `interface`, if unset eth0
- `framerate`, if unset 30
- `video_dev`, if unset /dev/video0
- `IP_local`, local address for http streams, by default IP address of `interface`
