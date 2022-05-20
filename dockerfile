FROM alpine:latest

MAINTAINER Cyber Mainstay "info@cybermainstay.com"

# For more automated updates, simply add NUT repo to the repo list
# If you want stable releases only, change 'edge' to 'last-stable'
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install NUT Server
RUN apk update && apk upgrade
RUN apk add nut
RUN apk cache clear

# Create directory for nut in /var/run
RUN mkdir -p /var/run/nut && \
	chown nut:nut /var/run/nut && \
	chmod 700 /var/run/nut

# Copy over the startup script
COPY files/startup.sh /startup.sh
RUN chmod 700 /startup.sh

ENTRYPOINT ["/startup.sh"]

EXPOSE 3493
