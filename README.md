# OpenWRT NCS601W (and clones) Config
This repository contains an OpenWRT patchset to maintain and adjust Wansview NCS601W functionality. These were developed and tested on two Belkin Netcam F7D7601v1 model cameras, but should work with the Wansview NCS601W, imogenstudio +CAM and Aztech WIPC303 as they appear to be clones. Be aware OpenWRT [does not recommend devices with 8MB of flash](https://openwrt.org/supported_devices/864_warning) and I'm unsure how long this patchset will be applicable or how long the NCS601W will be supported at all. I intend to periodiocally apply these patches to the OpenWRT main branch to confirm they still build a valid image.

## Flashing the firmware

### Requirements

 - TFTP server
 - USB to UART adapter

### Installation

Installing firmware requires opening of the device. You'll need to use of some kind of spudger to pry open the chassis and unclip the retention mechanism. Once you're in, you should see a 4 pin UART header clearly marked on the board. Boot up the device with your USB to UART adapter and COM terminal of choice (8N1 57600 baudrate), select U-BOOT option 2, and enter in your TFTP information. This will flash the image to your device. From here, you can check core functionality of the device. I set the default network configuration to DHCP on the ethernet port but this can be changed to whatever you desire via [OpenWRT's UCI configuration interface.](https://openwrt.org/docs/guide-user/base-system/uci) To reserve flash space, the standard LuCI WebUI is not installed, but the [ustreamer](https://github.com/pikvm/ustreamer) WebUI will be available at http://your-camera-ip-here:8080.

## Configuration

This image includes two new services `audio-streamer` and `ir-led` to use along with `ustreamer` to get full IP camera functionality. These can all be configured via UCI in `/etc/config` and are enabled by default.

### Camera/setup switch

The setup switch is connected to GPIO 512 and can be used in scripts however you'd like:

```sh
# Export the GPIO
echo 512 > /sys/class/gpio/export
# Set direction
echo in > /sys/class/gpio/gpio512/direction
# Get the value (0 is camera, 1 is setup)
cat /sys/class/gpio/gpio512/value
```

### RTSP

You can use a [go2rtc](https://go2rtc.org/) server to make an RTSP stream:

```yaml
streams:
  your_camera_name_here:
    - ffmpeg:http://camera-ip-here:8080/stream#video=h264#rotate=180
    - "ffmpeg:netcat#input=-f s16le -ar 16000 -ac 1 -i tcp://camera-ip-here:5000#audio=pcma"
```

---

Made possible by:

- [OpenWrt](https://openwrt.org/)  
- [ustreamer](https://github.com/pikvm/ustreamer)
- [go2rtc](https://github.com/AlexxIT/go2rtc)

Special thanks to [this article](http://wanda25.de/wansview_ncs601w.html) that got me started along with a [helpful comment on my blog.](https://cssev.net/2024/07/19/restoring-functionality-to-the-discontinued-belkin-netcam-f7d7601v1/#comment-3)
