# Use Ubuntu as base image
FROM ubuntu:24.04

# Set build arguments (not strictly needed unless you're customizing builds)
ARG RELEASE
ARG LAUNCHPAD_BUILD_ARCH

# Set labels (optional metadata)
LABEL org.opencontainers.image.ref.name=ubuntu
LABEL org.opencontainers.image.version=24.04

# Set working directory
WORKDIR /app

# Install system updates and dependencies (e.g., cowsay or figlet if needed)
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    figlet \
    cowsay \
    && rm -rf /var/lib/apt/lists/*

# Copy your custom script into the container
COPY wisecow.sh /app/wisecow.sh

# Make sure the script is executable
RUN chmod +x /app/wisecow.sh

# Expose the port the script will use
EXPOSE 4499

# Set the entrypoint to execute your script when container starts
ENTRYPOINT ["sh", "-c", "/app/wisecow.sh"]
