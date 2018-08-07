# Fang Hacks Internal
Collection of modifications for the XiaoFang WiFi Camera using only internal flash

The aim of this hack is to provide RTSP stream and basic telnet functionality without the need for a microsd card. This project uses RTSP server and IR controller from [fang-hacks](https://github.com/samtap/fang-hacks).

## Features
 - RTSP stream at ```rtsp://IP/unicast```
 - Telnet on port 2323 (```root:ismart12```)
 - RTSP stream [OSD manipulation](https://github.com/samtap/fang-hacks/wiki/Controlling-the-text-overlay).
 - A script controls the IR filter
 - Config update via text file on microsd card
 - [not a bug] all Xiaomi cloud apps are removed rendering all original cloud functions broken. You can return to factory state by flash-erase the /dev/mtd4 partition: ```/usr/sbin/flash_eraseall -j -q /dev/mtd4```

## DISCLAIMER
While this has been tested fairly extensively, I shall hold no responsibility if this brick your camera or kill your cat.

## General usage
Prepare a microsd card with 1 FAT partition. Copy ```config.txt```, ```files.tar```, ```snx_autorun.sh``` to the FAT partition. Make sure you check files.tar for corruption.

## Migrate from fang-hacks 
If you are already using samtap's fang-hacks. It is recommend that you wipe the internal flash before proceeding. This can be done by telnet to the device and issue the following command

```/usr/sbin/flash_eraseall -j -q /dev/mtd4 && halt```

Watch the status and as soon as the command return to the # prompt, remove the microsd, power-cycle the camera. This will now take a few minutes to reboot and repopulate /etc partition. Camera will start flashing amber/blue LED once ready.

## Initial Setup
 - Edit config.txt
 - Make sure camera is up and running
 - Insert microsd card, installation process will start. You will hear 4 quick beeps once and again when the files are transferred successfully to the internal flash.
 - Check your WiFi router for new IP (or reserve DHCP prior). ping should reply in about 1 minute.
 - You should now be able to telnet to port 2323 or rtsp://IP/unicast
 - Once confirmed working, remove the microsd and reboot the camera
 - Once installed, this intial setup will not be run again unless Chuck Norris mode is invoked -- see below.

## Updating SSID/PSK/etc.
 - Make change(s) in config.txt
 - Insert microsd card. You will hear 2 quick clinks when the new setting is applied.
 - Eject the card
 - Reboot XiaoFang

## Chuck Norris Mode
 - This mode will force the "Initial Setup" process described above, regardless of existing installation.
 - In config.txt, change CHUCKNORRIS to "true"
 - Make sure the camera is up and running then insert the card.
