# Flutter Base Image

Multi-platform Docker base image for Flutter web projects with support for ARM64, AMD64, and ARM/v7 architectures.

## Overview

This Docker image provides a Debian-based environment with Flutter SDK pre-installed and configured for web development. The image is built to support multiple CPU architectures, making it suitable for deployment across various platforms including Apple Silicon, Intel/AMD processors, and ARM devices.

## Supported Platforms

- `linux/amd64` - Intel/AMD 64-bit processors
- `linux/arm64` - ARM 64-bit processors (Apple Silicon, AWS Graviton, etc.)
- `linux/arm/v7` - ARM 32-bit processors (Raspberry Pi, etc.)

## Prerequisites

- Docker (with BuildKit support)
- Docker Buildx for multi-platform builds

## Version Management

The Flutter version is managed through the `version` file in the project root. To change the Flutter version:

1. Edit the `version` file with the desired version number (e.g., `3.38.3`)
2. Rebuild the Docker image

## Building the Image

### Single Platform Build

Build for your current platform:

```bash
docker build --build-arg FLUTTER_VERSION=$(cat version) -t flutter-base:$(cat version) .
```

### Multi-Platform Build

Build for all supported platforms and push to a registry:

```bash
# Create a new builder instance (first time only)
docker buildx create --name multiarch --use

# Build and push for all platforms
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  --build-arg FLUTTER_VERSION=$(cat version) \
  -t yourusername/flutter-base:$(cat version) \
  -t yourusername/flutter-base:latest \
  --push \
  .
```

Build for all platforms and load locally (single platform at a time):

```bash
docker buildx build \
  --platform linux/amd64 \
  --build-arg FLUTTER_VERSION=$(cat version) \
  -t flutter-base:$(cat version) \
  --load \
  .
```

## Using the Image

### As a Base Image

In your Flutter project's Dockerfile:

```dockerfile
FROM yourusername/flutter-base:3.38.3

COPY . /app
WORKDIR /app

RUN flutter pub get
RUN flutter build web
```

### Interactive Development

Start a container for interactive development:

```bash
docker run -it --rm -v $(pwd):/app flutter-base:$(cat version)
```

### Running Flutter Commands

```bash
# Check Flutter version
docker run --rm flutter-base:$(cat version) flutter --version

# Run Flutter doctor
docker run --rm flutter-base:$(cat version) flutter doctor
```

## What's Included

The base image includes:

- Debian Bookworm (slim variant)
- Flutter SDK (version specified in `version` file)
- Required dependencies:
  - curl
  - git
  - unzip
  - xz-utils
  - zip
  - libglu1-mesa
- Pre-configured Flutter web support
- Pre-cached Flutter web artifacts

## Environment Variables

- `FLUTTER_VERSION` - The Flutter SDK version (e.g., `3.38.3`)
- `FLUTTER_URL` - Complete download URL for the Flutter SDK
- `FLUTTER_HOME` - Flutter installation directory (`/opt/flutter`)
- `PATH` - Updated to include Flutter binaries

## File Structure

```
.
├── Dockerfile      # Multi-platform Dockerfile
├── README.md       # This file
└── version         # Flutter version number (e.g., 3.38.3)
```

## Updating Flutter Version

1. Update the version number in the `version` file
2. Rebuild the image using the build commands above
3. The Dockerfile will automatically construct the download URL using the version number

## Notes

- The image is optimized for Flutter web development
- Flutter dependencies are pre-cached to speed up builds
- The image uses Debian Bookworm slim to minimize size while maintaining compatibility
- Multi-platform builds require pushing to a registry; local loading only supports one platform at a time

## License

This project is provided as-is for building Flutter base images.
