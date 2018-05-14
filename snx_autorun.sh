#!/bin/sh

[ -z "${MDEV}" ] && return

if [ -e /media/${MDEV}/config.txt ] ; then
	source /media/${MDEV}/config.txt
	echo ${HOSTNAME} > /etc/hostname
	sed -i -e 's/ssid=".*"$/ssid="'${SSID}'"/g' /etc/wpa_supplicant.conf
	sed -i -e 's/psk=".*"$/psk="'${PSK}'"/g' /etc/wpa_supplicant.conf
	echo ${TZ} > /etc/TZ
fi

if [ ! -e /etc/rtsp ] ; then
	sed -i '/iSC3S/d' /etc/init.d/rcS

	kill -9 `pidof iCamera`
	kill -9 `pidof test_UP`
	kill -9 `pidof iSC3S`

	rm -rf /etc/app/*

	mkdir -p /etc/rtsp/
	cd /etc/rtsp/
	tar xf /media/${MDEV}/files.tar 
	cp /media/${MDEV}/config.txt .

	sed -i '/rtsp/d' /etc/init.d/rc.local
	echo "/etc/rtsp/my.rc.local & " >> /etc/init.d/rc.local

	sync && reboot
fi

