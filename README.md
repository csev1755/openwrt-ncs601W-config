# OpenWRT NCS601W Config

This repository contains an OpenWRT patchset to maintain and adjust Wansview NCS601W functionality. It's being developed and tested on two Belkin Netcam F7D7601v1 model cameras but should work with the Wansview NCS601W, imogenstudio +CAM, and Aztech WIPC303 as they appear to be clones.

See OpenWRT's guide on building images here: https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem

Sample go2rtc config:
```
streams:
  openwrt_camera:
    - ffmpeg:http://camera-ip-here:8080/stream#video=h264#rotate=180
    - "ffmpeg:netcat#input=-f s16le -ar 16000 -ac 1 -i tcp://camera-ip-here:5000#audio=pcma"
```
