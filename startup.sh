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

# Initialize UPSD
printf "Starting UPS drivers...\n"
/usr/sbin/upsdrvctl -u root start || { printf "ERROR: Unable to start UPS Drivers.\n"; exit; }

# Start the UPS Daemon
printf "Starting UPS daemon...\n"
/usr/sbin/upsd -u nut || { printf "ERROR: Unable to start UPSD.\n"; exit; }

# Start UPS Monitor service
exec /usr/sbin/upsmon -D


