# Syncthing for macOS design

## Compilation and packaging process

* Xcode builds all sources
* Syncthing resource is fetched with `syncthing/Scripts/syncthing-resource.sh`
* Syncthing inotify resource is fetch with `syncthing/Scripts/syncthing-inotify-resource.sh`
* Fancy DMG disk image is generated with `syncthing/Scripts/create-dmg.sh`
  * The version part of the DMG name is fetched from `syncthing/Info.plist, key CFBundleShortVersionString`
