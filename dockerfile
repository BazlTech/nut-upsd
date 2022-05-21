FROM alpine:latest

LABEL org.opencontainers.image.title: "nut-upsd" \
	org.opencontainers.image.description: "Network UPS Tools nut-upsd running in Alpine container" \
	org.opencontainers.image.licenses: "GNU General Purpose License v3.0" \
	org.opencontainers.image.vendor: "Cyber Mainstay" \
	org.opencontainers.image.version: "2.8.0-r0" \
	org.opencontainers.image.source: "https://networkupstools.org" \
	org.opencontainers.image.url: "https://github.com/CyberMainstay/nut-upsd" \
	org.opencontainers.image.authors: "Steven Bazzell"

# Open up more repositories so we can unstall nut
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install NUT Server
RUN apk update && apk upgrade
RUN apk add nut libcrypto1.1 libssl1.1 net-snmp-libs musl

# Create directory for nut in /var/run
RUN mkdir -p /var/run/nut && \
	chown nut:nut /var/run/nut && \
	chmod 700 /var/run/nut

# Copy over the startup script
COPY files/startup.sh /usr/local/bin/startup.sh
RUN chown root:nut /usr/local/bin/startup.sh
RUN chmod 700 /usr/local/bin/startup.sh

EXPOSE 3493

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
