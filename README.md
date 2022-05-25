# Network UPS Tools UPSD

Docker image for Network UPS Tools Driver Daemon

## Usage

This image has two operating modes, `single` and `custom` as declared by the ***UNIT_MODE*** ENV variable.
This way you can configure to your own needs for more than one UPS unit or a custom configuration.
In `single` mode, you'll need to declare the environmental variables for a single unit, just like many other
conatiner images for Network UPS Tools.  These variables will autoconfigure NUT for you.
If run in `custom` mode, you'll need to create the config files necessary, and map that volume to `/opt/nut/conf/`

## Environment Variables
#### UNIT_MODE
- This variable is `single` by default.
`custom` mode will require you to create the config files necessary and map them to /opt/nut/conf/

#### NUT_MODE
- This variable is `standalone` by default.  Any further advanced configuration will require you to 
set UNIT_MODE to `custom` and visit [NUT Docs](https://networkupstools.org/docs/man/nut.conf.html) for more details.

#### UPS_NAME
- Pretty obvious - whatever you want to call it.  Default value is "MyUPS"

#### UPS_DRIVER
- This is needed to set the driver to whatever your UPS unit requires for communication.
Default is "usbhid-ups"
- For more driver options, see [NUT Docs](https://github.com/networkupstools/nut/blob/master/data/driver.list.in)

#### UPS_PORT
- Default is 3493

#### UPS_DESC
- Set the description of your UPS unit.  Default is "Description"

#### UPS_VENDORID
- This is required for some manufacturers like APC and CyberPower.
Default is blank.

#### UPS_PRODUCTID
- Similar to UPS_VENDORID, this variable is needed by some manufacturers like APC and CyberPower.
Default is blank.

#### UPSMON_PASS
- Set a password for creating the UPSMON user account. 
Default is "password"

## Docker Deployment Extra Required Steps
#### Privileged Access
Most other nut-upsd images in the docker hub repo have you run the container in privileged mode.  Using more restrictive device mappings is more secure.
You may or may not have to adjust this.  Running `docker exec container_name nut-scanner -U` will tell you exactly what bus it is on.  Just make
sure that matches what is in your device mapping in your docker-compose file.

#### VENDORID and PRODUCTID
For UPS units that need these, you'll need to first deploy the container, and then run `docker exec container_name nut-scanner -U`
 which should give you the needed information.

### Docker-Compose UNIT_MODE=single Example

```console
version: '3.3'
services:
  
  nuts:
    image: nut-upsd
    container_name: nuts
    networks:
      - monitoring
    devices:
      - /dev/bus/usb/002:/dev/bus/usb/002
    device_cgroup_rules:
      - 'a 189:* rwm'
    mem_limit: 200m
    mem_reservation: 50m
    environment:
      UPS_NAME: APC1500
      UPS_DRIVER: usbhid-ups
      UPS_DESC: "APC1500VA Powering the firewall"
      UPS_VENDORID: "0744"
      UPS_PRODUCTID: "0532"
      UPSMON_PASS: "SuperSecretPASSWORD"
    restart: on-failure:2
    
networks:
  monitoring:
    external: false
```

### Docker-Compose UNIT_MODE=custom Example

```console
version: '3.3'
services:
  
  nuts:
    image: nut-upsd
    container_name: nuts
    networks:
      - monitoring
    volumes:
      - /srv/docker/volumes/nuts:/opt/nut/conf/
    devices:
      - /dev/bus/usb/002:/dev/bus/usb/002
    device_cgroup_rules:
      - 'a 189:* rwm'
    mem_limit: 200m
    mem_reservation: 50m
    environment:
      UNIT_MODE: custom
    restart: on-failure:2
    
networks:
  monitoring:
    external: false
```

## Config Files

You'll need
