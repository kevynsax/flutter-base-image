# Multi-platform Flutter base image
# Supports: linux/amd64, linux/arm64, linux/arm/v7

FROM debian:bookworm-slim

# Read Flutter version from build arg
ARG FLUTTER_VERSION
ENV FLUTTER_VERSION=${FLUTTER_VERSION}

# Set Flutter installation directory
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Install prerequisite packages
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK from git repository
# This approach works for all architectures (amd64, arm64, arm/v7)
# as Flutter will build/download the appropriate binaries for the host architecture
RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    cd ${FLUTTER_HOME} && \
    git checkout ${FLUTTER_VERSION} && \
    git config --global --add safe.directory ${FLUTTER_HOME}

# Pre-cache Flutter dependencies and configure for web
RUN flutter precache --web && \
    flutter config --enable-web && \
    flutter --version

# Set working directory
WORKDIR /app

# Default command
CMD ["/bin/bash"]
