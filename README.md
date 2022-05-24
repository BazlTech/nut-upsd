# Network UPS Tools UPSD

Docker image for Network UPS Tools Driver Daemon

## Usage

This image does not use environmental variables to configure NUT config files like many other images. 
This way you can configure to your own needs for more than one UPS unt, allowing you to run a single container for multiple units.

## Docker-Compose Example

```console
version: '3.3'
services:
  
  nuts:
    image: nut-upsd
    container_name: nuts
    networks:
      - monitoring
    volumes:
      - /srv/docker/volumes/nuts:/etc/nut
    devices:
      - /dev/bus/usb/002:/dev/bus/usb/002
    device_cgroup_rules:
      - 'a 189:* rwm'
    mem_limit: 200m
    mem_reservation: 50m
    restart: on-failure:2
    
networks:
  monitoring:
    external: false
```

## Config Files

You'll need
