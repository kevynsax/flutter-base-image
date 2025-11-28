# Multi-platform Flutter base image
# Supports: linux/amd64, linux/arm64, linux/arm/v7

FROM debian:bookworm-slim

# Read Flutter version from build arg
ARG FLUTTER_VERSION
ARG TARGETARCH
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

# Download and extract Flutter SDK based on architecture
RUN mkdir -p /opt && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_arm64_${FLUTTER_VERSION}-stable.tar.xz"; \
    elif [ "$TARGETARCH" = "arm" ]; then \
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_arm64_${FLUTTER_VERSION}-stable.tar.xz"; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; exit 1; \
    fi && \
    echo "Downloading Flutter for $TARGETARCH from $FLUTTER_URL" && \
    curl -o /tmp/flutter.tar.xz ${FLUTTER_URL} && \
    tar -xf /tmp/flutter.tar.xz -C /opt && \
    rm /tmp/flutter.tar.xz

# Configure Git to allow Flutter directory and pre-download Flutter dependencies
RUN git config --global --add safe.directory /opt/flutter && \
    flutter precache --web && \
    flutter config --enable-web && \
    flutter --version

# Set working directory
WORKDIR /app

# Default command
CMD ["/bin/bash"]
