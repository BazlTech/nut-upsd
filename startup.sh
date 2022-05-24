#!/bin/sh
#
# Network UPS Tools for Docker UPSD Script
#
# AUTHOR:	Cyber Mainstay
#
# DISCLAIMER:	Use this software at your own risk.  By using this software
#		you agree to idemnify Cyber Mainstay and its employees and
#		affiliates involved with the creation of this software.
#
# DESCRIPTION:	Startup script for the nut-upsd docker container image.
#

# Ignore PID warning message
echo 0 > /var/run/nut/upsd.pid && chown nut:nut /var/run/nut/upsd.pid
echo 0 > /var/run/upsmon.pid

# Check for operational modes and create config files if necessary
# Set NUT mode
echo "MODE = $NUT_MODE" > /etc/nut/nut.conf

# Set UPS variables in ups.conf
echo "pollinterval = 1" > /etc/nut/ups.conf
echo "maxretry = 3" >> /etc/nut/ups.conf
echo "[$UPS_NAME]" >> /etc/nut/ups.conf
echo "driver = $UPS_DRIVER" >> /etc/nut/ups.conf
echo "port = $UPS_PORT" >> /etc/nut/ups.conf
echo "desc = $UPS_DESC" >> /etc/nut/ups.conf
echo "vendorid = $UPS_VENDORID" >> /etc/nut/ups.conf
echo "productid = $UPS_PRODUCTID" >> /etc/nut/ups.conf

# Set up UPSD configuration in upsd.conf
if [[ "$UNIT_MODE" == "single" ]]
then
	echo "LISTEN 127.0.0.1 3493" > /etc/nut/upsd.conf
	#echo "LISTEN ::1 3493" >> /etc/nut/upsd.conf
else
	echo "LISTEN 0.0.0.0 3493" > /etc/nut/upsd.conf
	#echo "LISTEN :: 3493" >> /etc/nut/upsd.conf
fi

# Set up UPS monitor config file in upsd.users
echo "[upsmon]" > /etc/nut/upsd.users
echo "password = $UPSMON_PASS" >> /etc/nut/upsd.users
echo "upsadmin master" >> /etc/nut/upsd.users

# Set up the monitoring in upsmon.conf
echo "MONITOR $UPS_NAME@localhost 1 upsmon $UPSMON_PASS master" > /etc/nut/upsmon.conf

# If using this container in a custom or multiple-unit mode, copy over mapped volume config files
# from /opt/nut/conf/
if [[ "$UNIT_MODE" != "single" ]]
then
	COUNTFILES=`ls 2>/dev/null -Ubad1 -- /opt/nut/conf/* | wc -l`
	if [[ $COUNTFILES -lt 4 ]]
		then
			echo "MISSING CONFIG FILES.  EXITING."
			exit N
		else 
			cp /opt/nut/conf/* /etc/nut/
	fi
fi

# Initialize UPSD
printf "Starting UPS drivers...\n"
/usr/sbin/upsdrvctl -u root start || { printf "ERROR: Unable to start UPS Drivers.\n"; exit; }

# Start the UPS Daemon
printf "Starting UPS daemon...\n"
/usr/sbin/upsd -u nut || { printf "ERROR: Unable to start UPSD.\n"; exit; }

# Start UPS Monitor service
exec /usr/sbin/upsmon -D


