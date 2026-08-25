# Android Emulator for SealSkin

Selkies-compatible Android Emulator image for running an Android session in SealSkin.
It uses the LinuxServer Selkies base image, Android API 34, and an x86_64 Google APIs system image.

## Build

```bash
docker build -t masuddh/sealskin:1.0.0 .
```

## SealSkin Configuration

Use the image `masuddh/sealskin:1.0.0` for the Android Emulator application and set its autostart command to:

```bash
emulator -avd selkies-android -gpu swiftshader_indirect -no-boot-anim -accel auto
```

The AVD enables hardware keyboard input so physical keys from the Selkies client can reach Android.

## Docker Hub

https://hub.docker.com/r/masuddh/sealskin