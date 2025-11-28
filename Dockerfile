# Multi-platform Flutter base image
# Supports: linux/amd64, linux/arm64
# Note: ARM/v7 (32-bit) is not supported by Flutter's Dart SDK

FROM debian:bookworm-slim

ARG FLUTTER_VERSION
ENV FLUTTER_VERSION=${FLUTTER_VERSION}

ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    cd ${FLUTTER_HOME} && \
    git config --global --add safe.directory ${FLUTTER_HOME} && \
    git fetch --depth=1 origin tag ${FLUTTER_VERSION} && \
    git checkout ${FLUTTER_VERSION}

RUN flutter doctor -v && \
    flutter precache --web && \
    flutter config --enable-web && \
    flutter --version && \
    rm -rf ${FLUTTER_HOME}/.pub-cache/hosted/pub.dartlang.org/*/test && \
    rm -rf ${FLUTTER_HOME}/.pub-cache/hosted/pub.dartlang.org/*/example

WORKDIR /app

CMD ["/bin/bash"]
