#!/bin/sh

[ -z "${MDEV}" ] && return

gpio_aud write 1 4 1

if [ -e /media/${MDEV}/config.txt ] ; then
	source /media/${MDEV}/config.txt
	hostname ${HOSTNAME}
	echo ${HOSTNAME} > /etc/hostname
	sed -i -e 's/ssid=".*"$/ssid="'${SSID}'"/g' /etc/wpa_supplicant.conf
	sed -i -e 's/psk=".*"$/psk="'${PSK}'"/g' /etc/wpa_supplicant.conf
	echo ${TZ} > /etc/TZ
	ps | grep -E "(udhcpc|wpa_supplicant)" | grep -v grep | sed 's/^\s*//' | cut -d " " -f 1 | xargs kill -9
	wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf &
	udhcpc -i wlan0 -p /var/run/udhcpc.pid -b &
	/etc/rtsp/pcm_play /usr/share/notify/binbin.wav
fi

if [ ! -e /etc/rtsp/OK -o "${CHUCKNORRIS}" == "true" ] ; then

	MYSUM=`md5sum /media/${MDEV}/files.tar|cut -d " " -f1`

	if [ "${MYSUM}" != "${MD5SUM}" ] ; then
		return
	fi

	ps | grep -E "(etc|ntp|udhcpc|iCamera|test_UP|iSC3S|wpa_supplicant)" | grep -v grep | sed 's/^\s*//' | cut -d " " -f 1 | xargs kill -9

	tar xf /media/mmcblk0p1/files.tar -C /tmp/ pcm_play

	/tmp/pcm_play /usr/share/notify/CN/speaker.wav

	rm -rf /etc/app /etc/miio* /etc/rtsp

	mkdir -p /etc/rtsp/
	cd /etc/rtsp/
	tar xf /media/${MDEV}/files.tar 
	cp /media/${MDEV}/config.txt .
	chown root:root /etc/rtsp/ -R

	sed -i '/iSC3S/d' /etc/init.d/rcS
	sed -i '/singleBoadTest/d' /etc/init.d/rcS
	sed -i 's/^modprobe snx_wdt/\#modprobe snx_wdt/' /etc/init.d/rcS

	sed -i '/rtsp/d' /etc/init.d/rc.local
	echo "/etc/rtsp/my.rc.local & " >> /etc/init.d/rc.local

	touch /etc/rtsp/OK

	/etc/rtsp/pcm_play /usr/share/notify/CN/speaker.wav

	/etc/rtsp/my.rc.local &
fi
