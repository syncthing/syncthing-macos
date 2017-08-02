# Syncthing for macOS design

## Versioning scheme

It uses the shipped syncthing executable version appended with a `-<build>` number.
So for Syncthing `0.14.24` with first build/package it is versioned as `0.14.24-1`.
Currently there is no need for having a separate version from syncthing.

## Compilation and packaging process

* Xcode builds all sources
* Syncthing resource is fetched with `syncthing/Scripts/syncthing-resource.sh`
* Syncthing inotify resource is fetched with `syncthing/Scripts/syncthing-inotify-resource.sh`
* Fancy DMG disk image is generated with `syncthing/Scripts/create-dmg.sh`
  * The version part of the DMG name is fetched from `syncthing/Info.plist, key CFBundleShortVersionString`
* Both the app bundle and the DMG are signed with the first available Developer ID certificate, if found (or the one specified through SYNCTHING_APP_CODE_SIGN_IDENTITY environment variable)

`syncthing-macosx` will only ship [stable releases and no release candidates](https://forum.syncthing.net/t/introducing-stable-releases-and-release-candidates/9167).
