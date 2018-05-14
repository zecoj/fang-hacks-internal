# Fang Hacks Internal
Collection of modifications for the XiaoFang WiFi Camera using only internal flash

The idea of this hack is to provide RTSP stream and basic telnet functionality without the need for a microsd card.

## General usage

Prepare a microsd card with 1 FAT partition. Copy ```config.txt```, ```files.tar```, ```snx_autorun.sh``` to the FAT partition.

## Initial Setup
 - Edit config.txt
 - Make sure camera is up and running
 - Insert microsd card, Xiaofang will reboot upon completion
 - Check your WiFi router for new IP (or reserve DHCP prior). ping should replies in about 1 minute.
 - You should now be able to telnet to port 2323 or rtsp://IP/unicast

## Updating SSID/PSK/etc.
 - Make change(s) in config.txt
 - Insert microsd card
 - Wait 10 seconds, eject the card
 - Reboot Xiaofang
