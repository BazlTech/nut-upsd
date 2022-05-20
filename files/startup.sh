#!/bin/sh
#
#
# Network UPS Tools for Docker UPSD Script
#
#
# AUTHOR:	Cyber Mainstay
#
# DISCLAIMER:	Use this software at your own risk.  By using this software
#		you agree to idemnify Cyber Mainstay and its employees and
#		affiliates involved with the creation of this software.
#
# DESCRIPTION:	This script will check for config files needed to run upsd.
#

# Initialize UPSD
printf "Starting UPS drivers...\n"
/usr/sbin/upsdrvctl -u root start || { printf "ERROR: Unable to start UPS Drivers.\n"; exit; }

# Start the UPS Daemon
printf "Starting UPS daemon...\n"
/usr/sbin/upsd -u nut || { printf "ERROR: Unable to start UPSD.\n"; exit; }



