# Android Emulator for SealSkin

Selkies-compatible Android Emulator image for running an Android session in SealSkin.
It uses the LinuxServer Selkies base image, Android API 34, and an x86_64 Google APIs system image.

## Build

```bash
docker build -t masuddh/sealskin:1.0.0 .
```

## SealSkin Configuration

Create or edit the Android Emulator app with these provider settings:

```yaml
provider: docker
provider_config:
  image: masuddh/sealskin:1.0.0
  port: 3000
  type: app
  url_support: true
  open_support: true
  autostart: false
  docker_overrides: null
```

Set both the regular and Wayland custom autostart scripts to:

```bash
emulator -avd selkies-android -gpu swiftshader_indirect -no-boot-anim -accel auto
```

Keep `docker_overrides` as `null`. The image already provides the Selkies desktop,
Android SDK, AVD, and `/dev/kvm` support through the SealSkin runtime.

The AVD enables hardware keyboard input so physical keys from the Selkies client can reach Android.

## Docker Hub

https://hub.docker.com/r/masuddh/sealskin