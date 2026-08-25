# Selkies/SealSkin-compatible Android emulator app.
# Base: LinuxServer's Selkies base image (bundles the selkies streaming server,
# pixelflux/pcmflux, and the Labwc/Openbox session SealSkin's proxy expects).
FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

# API level / ABI / hardware profile of the AVD created at build time.
ARG ANDROID_API_LEVEL=34
ARG ANDROID_ARCH=x86_64
ARG ANDROID_DEVICE=pixel
# cmdline-tools build id from https://developer.android.com/studio#command-tools
ARG ANDROID_CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_AVD_HOME=/opt/android-sdk/avd
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-21-jre-headless \
        unzip \
        curl \
        qemu-system-x86 \
        libpulse0 \
        libgl1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# cmdline-tools ship one directory level too deep; sdkmanager expects .../cmdline-tools/latest/bin
RUN mkdir -p "${ANDROID_HOME}/cmdline-tools" && \
    curl -fsSL -o /tmp/cmdline-tools.zip "${ANDROID_CMDLINE_TOOLS_URL}" && \
    unzip -q /tmp/cmdline-tools.zip -d "${ANDROID_HOME}/cmdline-tools" && \
    mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest" && \
    rm /tmp/cmdline-tools.zip

# Accept licenses non-interactively, then pull only what the emulator needs to boot.
RUN yes | sdkmanager --licenses >/dev/null && \
    sdkmanager --install \
        "platform-tools" \
        "emulator" \
        "platforms;android-${ANDROID_API_LEVEL}" \
        "system-images;android-${ANDROID_API_LEVEL};google_apis;${ANDROID_ARCH}"

# Build the AVD once so the first session launch doesn't pay the setup cost.
# ANDROID_AVD_HOME above keeps it out of $HOME, which the runtime session user
# (not root, and not necessarily the same UID as the build) would not see.
RUN mkdir -p "${ANDROID_AVD_HOME}" && \
    echo "no" | avdmanager create avd \
        --name "selkies-android" \
        --package "system-images;android-${ANDROID_API_LEVEL};google_apis;${ANDROID_ARCH}" \
        --device "${ANDROID_DEVICE}" \
        --force && \
    sed -i 's/^hw.keyboard = .*/hw.keyboard = yes/' \
        "${ANDROID_AVD_HOME}/selkies-android.avd/config.ini" && \
    chmod -R 777 "${ANDROID_HOME}"

COPY root/ /
