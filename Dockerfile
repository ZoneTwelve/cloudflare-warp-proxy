# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    iptables \
    && rm -rf /var/lib/apt/lists/*

# Install Cloudflare WARP
RUN curl https://pkg.cloudflareclient.com/pubkey.gpg | \
    gpg --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/cloudflare-client.list \
    && apt-get update && apt-get install -y cloudflare-warp \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/lib/cloudflare-warp

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables (these can be overridden by the .env file)
ENV organization=""
ENV auth_client_id=""
ENV auth_client_secret=""
ENV warp_connector_token=""

# Enable IP forwarding
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# Expose necessary ports (modify as needed)
# EXPOSE 80

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

