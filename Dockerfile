#
# Openfire Dockerfile
# https://github.com/gedeeinstein/docker-openfire
#

# 1. Set the Base Image to Ubuntu 24.04
FROM ubuntu:24.04

# Maintainer
LABEL maintainer="Your Name <your.email@example.com>"

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Define Openfire version and download URL
ARG OPENFIRE_VERSION=5.0.1
ARG OPENFIRE_URL=https://igniterealtime.org/downloadServlet?filename=openfire/openfire_${OPENFIRE_VERSION}_all.deb
ARG OPENFIRE_HOME=/var/lib/openfire

# 2. Update, install dependencies, and download Openfire
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    # Openfire requires a Java Runtime Environment. 'headless' is smaller.
    default-jre-headless && \
    echo "Downloading Openfire ${OPENFIRE_VERSION}..." && \
    wget -O /tmp/openfire.deb "${OPENFIRE_URL}" && \
    echo "Installing Openfire..." && \
    dpkg -i /tmp/openfire.deb && \
    # Clean up to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# 3. Define mountable directories for persistent data.
VOLUME [ \
  "${OPENFIRE_HOME}/conf", \
  "${OPENFIRE_HOME}/plugins", \
  "${OPENFIRE_HOME}/embedded-db", \
  "${OPENFIRE_HOME}/logs", \
  "${OPENFIRE_HOME}/resources/security" \
]

# 4. Expose the necessary ports for Openfire and its components
# 9090: Admin Console (HTTP)
# 9091: Admin Console (HTTPS)
# 5222: Client to Server (Standard XMPP)
# 5223: Client to Server (Old SSL)
# 7777: File Transfer Proxy
# 448: Google Play Services (FCM) - Note: This is an outbound port, exposing it is unusual.
# 5229: Flash Cross Domain
# 5262: Server to Server (Dialback - Legacy)
# 5263: Server to Server (Dialback - SSL Legacy)
# 5269: Server to Server (Federation)
# 5270: Server to Server (Federation - Old SSL)
# 5275: Component Protocol (External Components)
# 5276: Component Protocol (External Components - SSL)
# 7070: HTTP Binding (BOSH)
# 7443: HTTPS Binding (BOSH)
# 9997: Not a standard Openfire port, included as requested.
EXPOSE 9090 9091 5222 5223 7777 448 5229 5262 5263 5269 5270 5275 5276 7070 7443 9997

# Set the working directory
WORKDIR ${OPENFIRE_HOME}

# Set the entrypoint to start Openfire
ENTRYPOINT ["/usr/bin/openfire.sh"]
