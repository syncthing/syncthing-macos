# Syncthing for macOS design

## Dependency management

[CocoaPods](https://cocoapods.org/) is used for dependency management. It can be installed with [Homebrew](https://brew.sh/) package manager. For more information about CocoaPods read the [CocoaPods Guides](https://guides.cocoapods.org/).

## Versioning scheme

It uses the shipped syncthing executable version appended with a `-<build index>` number.
So for Syncthing `0.14.28` with first build/package it is versioned as `0.14.28-1`.
Currently there is no need for having a separate version for `syncthing-macos`. As it also keeps the wrapper tightly coupled with the syncthing releases.

## Compilation and packaging process

* Xcode builds all sources
* Syncthing resource is fetched with `syncthing/Scripts/syncthing-resource.sh`
* Fancy DMG disk image is generated with `syncthing/Scripts/create-dmg.sh`
  * The version part of the DMG name is fetched from `syncthing/Info.plist, key CFBundleShortVersionString`
* Both the app bundle and the DMG are signed with the first available Developer ID certificate, if found (or the one specified through `SYNCTHING_APP_CODE_SIGN_IDENTITY` environment variable)

`syncthing/syncthing-macos` will only ship [stable releases and no release candidates](https://forum.syncthing.net/t/introducing-stable-releases-and-release-candidates/9167) of the Syncthing Service (daemon).

## New release

* Update `syncthing/Scripts/syncthing-resource.sh`, `SYNCTHING_VERSION`
* Update `syncthing/Info.plist`
  * `CFBundleShortVersionString` (e.g `0.14.50-dev` or `0.14.50-1`)
  * `CFBundleVersion` (e.g `145000` or `145001`)
* Create git tag on develop
* Merge develop to master branch
