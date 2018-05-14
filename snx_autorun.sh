#!/bin/sh

[ -z "${MDEV}" ] && return

if [ -e /media/${MDEV}/config.txt ] ; then
	source /media/${MDEV}/config.txt
	echo ${HOSTNAME} > /etc/hostname
	sed -i -e 's/ssid=".*"$/ssid="'${SSID}'"/g' /etc/wpa_supplicant.conf
	sed -i -e 's/psk=".*"$/psk="'${PSK}'"/g' /etc/wpa_supplicant.conf
	echo ${TZ} > /etc/TZ
fi

MYSUM=`md5sum /media/${MDEV}/files.tar|cut -d " " -f1`

if [ "${MYSUM}" != "${MD5SUM}" ] ; then
	return
else
	continue
fi

if [ ! -e /etc/rtsp/OK -o "${CHUCKNORRIS}" == "true" ] ; then
	kill -9 `pidof iCamera`
	kill -9 `pidof test_UP`
	kill -9 `pidof iSC3S`
	kill -9 `pidof rtsp-watchdog`
	kill -9 `pidof ir-control`
	kill -9 `pidof ntpd`
	kill -9 `pidof wpa_supplicant`
	kill -9 `pidof udhcpc`
	kill -9 `pidof snx_rtsp_server`

	rm -rf /etc/app /etc/miio* /etc/rtsp

	mkdir -p /etc/rtsp/
	cd /etc/rtsp/
	tar xf /media/${MDEV}/files.tar 
	cp /media/${MDEV}/config.txt .
	chown root:root /etc/rtsp/ -R

	sed -i '/iSC3S/d' /etc/init.d/rcS

	sed -i '/rtsp/d' /etc/init.d/rc.local
	echo "/etc/rtsp/my.rc.local & " >> /etc/init.d/rc.local

	touch /etc/rtsp/OK

	/etc/rtsp/my.rc.local &
fi
