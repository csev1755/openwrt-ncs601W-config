# OpenWRT NCS601W (and clones) Custom Firmware Image
This repository contains an OpenWRT patchset to maintain and adjust **Wansview NCS601W** functionality. These were developed and tested on two **Belkin Netcam F7D7601v1** model cameras, but should work with the **Wansview NCS601W**, **imogenstudio +CAM** and **Aztech WIPC303** as they appear to be clones. Be aware OpenWRT [does not recommend devices with 8MB of flash](https://openwrt.org/supported_devices/864_warning) and I'm unsure how long this patchset will be applicable or how long the NCS601W will be supported at all. I will do my best to periodiocally apply these patches to the OpenWRT main branch to confirm they still build a valid image.

## Flashing the firmware

### Requirements

 - TFTP server
 - UART adapter

### Installation

   1. Pry open the chassis and connect to the labeled UART header (57600 baud 8N1)
   2. Power on the camera and choose U-Boot option: `2: Load system code then write to Flash via TFTP`

> [!NOTE]
> If the device doesn't behave as expected with UART attached, it's possible that voltage from the UART adapter is affecting the SoC's bootstrap configuration pins. Try powering on the device with the UART adapter disconnected and plug it back in a few seconds later.

## Configuration

The camera will attempt to get an IP via DHCP on the Ethernet port. To conserve flash space, the standard LuCI WebUI is not included. Settings are available via [OpenWrt's UCI configuration interface](https://openwrt.org/docs/guide-user/base-system/uci). This image also includes two new services, `audio-streamer` and `ir-led`, to use along with [ustreamer](https://github.com/pikvm/ustreamer) for full IP camera functionality. These are all enabled by default.

The camera/setup toggle switch is connected to GPIO 512 and can be used in scripts:

```sh
# Export the GPIO
echo 512 > /sys/class/gpio/export
# Set direction
echo in > /sys/class/gpio/gpio512/direction
# Get the value (0 is camera, 1 is setup)
cat /sys/class/gpio/gpio512/value
```

## Viewing the stream

The ustreamer WebUI is available at `http://your-camera-ip:8080` for viewing video without audio. To include audio and support NVR setups, you can use a [go2rtc](https://go2rtc.org/) server to make an RTSP stream:

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
