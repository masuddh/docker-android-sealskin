# Android Emulator for SealSkin

Selkies-compatible Android Emulator image for running an Android session in SealSkin.
It uses the LinuxServer Selkies base image, Android API 34, and an x86_64 Google APIs system image.

## Build

```bash
docker build -t masuddh/docker-android-sealkin:1.0.1 .
```

## SealSkin Configuration

In SealSkin, open **Install My Custom App** and enter:

| Field | Value |
| --- | --- |
| Custom Name | `Android Emulator` |
| Container Image | `masuddh/docker-android-sealkin:1.0.1` |
| Allowed Users | `all` |
| Allowed Groups | `all` |
| GPU Support | Enabled |
| Home Directory Mounting | Enabled |
| URL Opening Support | Enabled |
| File Opening Support | Enabled |
| Auto Update Image | Enabled |
| Application Template | `android` |

Set this in **Custom Autostart Script**:

```bash
emulator -avd selkies-android -gpu swiftshader_indirect -no-boot-anim -accel auto
```

Set the same command in **Custom Autostart Script (Wayland)**.

Click **Save Installation**. Do not add Docker overrides; the image already provides
the Selkies desktop, Android SDK, AVD, and `/dev/kvm` support through the SealSkin runtime.

The AVD enables hardware keyboard input so physical keys from the Selkies client can reach Android.

## Docker Hub

https://hub.docker.com/r/masuddh/docker-android-sealkin