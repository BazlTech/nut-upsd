FROM alpine:latest

LABEL org.opencontainers.image.title: "nut-upsd" \
	org.opencontainers.image.description: "Network UPS Tools nut-upsd running in Alpine container" \
	org.opencontainers.image.licenses: "GNU General Purpose License v3.0" \
	org.opencontainers.image.vendor: "Cyber Mainstay" \
	org.opencontainers.image.version: "2.8.0-r0" \
	org.opencontainers.image.source: "https://networkupstools.org" \
	org.opencontainers.image.url: "https://github.com/CyberMainstay/nut-upsd" \
	org.opencontainers.image.authors: "Steven Bazzell"

# Open up more repositories so we can install needed packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Run updates to repo and install nut
RUN apk --no-cache upgrade && apk add --no-cache nut libcrypto1.1 libssl1.1 net-snmp-libs musl

# Create directory for nut in /var/run
RUN mkdir -p /var/run/nut && \
	chown nut:nut /var/run/nut && \
	chmod 700 /var/run/nut

# Create a directory for manual nut config files
RUN mkdir /opt/nut/conf && \
	chown nut:nut /opt/nut/conf && \
	chmod 700 /opt/nut/conf

##### Setup some environment variables #####
#
# If running this instance for a single UPS unit, you MUST declare the ENV variables
# If yunning this instance for multiple UPS units (whether connected locally or
# via networking using netserver/netclient), you MUST set the UNIT_MODE variable
# to 'mutiple' and manually create/edit the configuration files.
# Config files should be placed in a mapped volumne to /opt/nut/conf/
ENV UNIT_MODE="single"

# Configure the NUT operational mode.  Can be 'standalone', 'netserver', or 'netclient' 
# Default operational mode is 'standalone'
# For more information, visit https://networkupstools.org/docs/man/nut.conf.html
ENV NUT_MODE="standalone"

# Set up UPS configuration.
# Default driver set to 'usbhid-ups' - You will need to set this to what your UPS unit needs
# For more driver information, visit https://github.com/networkupstools/nut/blob/master/data/driver.list.in
ENV UPS_DRIVER="usbhid-ups"

# Port is almost always auto unless you have a use case otherwise
ENV UPS_PORT="auto"
ENV UPS_DESC="Description"

# You will need to set the vendorid and productid for certain brands like APC and CyberPower
ENV UPS_VENDORID=""
ENV UPS_PRODUCTID=""

# Set up UPS monitor user and password
ENV UPSMON_PASS="password"

# Copy over the startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chown root:nut /usr/local/bin/startup.sh
RUN chmod 700 /usr/local/bin/startup.sh

# This is only needed if you are going to be using a client/server config
# or using a program like Prometheus to query nut-upsd
EXPOSE 3493

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
