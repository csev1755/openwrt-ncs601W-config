# OpenWRT NCS601 (and clones) RTSP Config
This repository contains scripts, file customization, and instructions for the Wansview NCS601W OpenWRT image to get video and audio from the device via an RTSP stream. This was developed and tested on two Belkin Netcam F7D7601v1 model cameras but should work with the Wansview NCS601W and possibly the imogenstudio +CAM. The OpenWRT image used is 19.07.10. Please note this version is no longer maintained, may have security vulnerabilities, and should only be used on a secure network. 

## Requirements

 - TFTP server
 - USB to UART adapter
 - go2rtc server
 
## Flashing/configuration instructions

Installing firmware requires opening of the device. You'll need to use of some kind of spudger to pry open the chassis and unclip the retention mechanism. Once you're in, you should see a 4 pin UART header clearly marked on the board. Boot up the device with your USB to UART adapter and COM terminal of choice (8N1 57600 baudrate), select U-BOOT option 2, and enter in your TFTP information. This will flash the image to your device. From here, you can check core functionality of the device. I set the default network configuration to DHCP on the ethernet port but this can be changed to whatever you desire via [OpenWRT's UCI configuration interface.](https://openwrt.org/docs/guide-user/base-system/uci) To reserve flash space, there is no web UI. 

At this point, if you don't already have a go2rtc server set up, you'll want to do so. Use the following configuration:

```yaml
streams:
  your_camera_name_here:
  # MJPEG stream, replace IP with your camera's IP
  - ffmpeg:http://192.168.1.1:8080/?action=stream#video=h264#rotate=180
  # UDP audio stream, replace IP with your go2rtc server's IP and port
  - ffmpeg:rtp://192.168.1.2:5001
```

Make sure the switch on the back is set to camera mode. In configuration mode, the switch prevents mjpg-streamer, Gstreamer, and the auto IR LED script from starting on boot if desired.

Now, you can edit the files in /root accordingly and reboot the device. You should now have a UDP audio stream pointed to your go2rtc server and an MJPEG video stream accessible via your camera's IP. There will also be an RTSP video stream from go2rtc available at its IP you can use as you wish.

## File explanations

**/etc/modules.d/video-uvc**
On boot, loads the uvcvideo module with the required quirks to get the USB camera to work

**/etc/rc.local**
Commands to run after init process is done to start the video and audio streams (if the camera mode switch is selected)

**/root/led.sh**
Script to turn the LED light on according to the status of the light sensor

**/root/go2rtc_ip**
Contains the IP address of your go2rtc server to point the audio stream

**/root/go2rtc_port**
Contains the port you want to use for the audio stream

**/etc/config/network**
UCI file to set the ethernet port to DHCP by default

## Made possible by

[OpenWrt](https://openwrt.org/)
[mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer)
[Gstreamer](https://gstreamer.freedesktop.org/)
[go2rtc](https://github.com/AlexxIT/go2rtc)

Special thanks to the following article where lots of device specific information came from: http://wanda25.de/wansview_ncs601w.html
