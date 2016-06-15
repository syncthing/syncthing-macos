# Syncthing for Mac OS X

![stability-beta](https://img.shields.io/badge/stability-beta-yellow.svg)
[![PayPal.Me](https://img.shields.io/badge/donate-PayPal-green.svg?style=flat)](https://paypal.me/xorgate) [![Downloads](https://img.shields.io/github/downloads/xor-gate/syncthing-macosx/total.svg)](https://github.com/xor-gate/syncthing-macosx/releases) [![Latest release](https://img.shields.io/github/release/xor-gate/syncthing-macosx.svg)](https://github.com/xor-gate/syncthing-macosx/releases/latest) [![Build Status](https://travis-ci.org/xor-gate/syncthing-macosx.svg?branch=master)](https://travis-ci.org/xor-gate/syncthing-macosx) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)

Native systray application for Mac OS X 10.10 and higher.

* Shows syncthing icon status (connected/not-connected)
* Tray menu
  * Open syncthing web-gui
  * Preferences pane
    * URI
    * API-key
  * Quit application and syncthing instance
* Shows systray tooltip
  * Current (connection) state
  * Current connection URI to syncthing
  * Current uptime (in seconds) (needs human readable conversion).

# Why

I wrote this in a weekend because all the cross-platform approaches didn't worked well natively. The application is functional and needs further testing. I run it daily.

# Build

Build with XCode or run:

```
xcodebuild
```

It will automaticly download syncthing amd64 binary and add it to the Application. The fancy
 DMG is also created automaticly.

# Syncthing ApiKey

You need to configure your API key in the preferences dialog as the application only starts a syncthing instance
 and a system tray. You can fetch your current API key:

`sed -n 's:.*<apikey>\(.*\)</apikey>.*:\1:p' $HOME/Library/Application\ Support/Syncthing/config.xml`

You must restart the application to work (for now).

# Configuration and defaults

Writing defaults is handled by OS X and can be set from the GUI or console.

`defaults write com.github.xor-gate.syncthing-macosx <config> <value>`

* `Executable` : "/path/to/syncthing" (overwrite, will defaults use `<Syncthing.app>/MacOS/Resources/syncthing/syncthing>`)
* `ApiKey`: "<ApiKey>"
* `URI`: "http://localhost:8384"

Example:

```
defaults write com.github.xor-gate.syncthing-macosx URI "http://localhost:8384"
defaults write com.github.xor-gate.syncthing-macosx ApiKey 1234
```

# Reusable library

I'm trying to create a native Objective-C library to access Syncthing REST API.
See [`XGSyncthing.h`](syncthing/XGSyncthing.h).

# Contributions

I appreciate code and project contributions and possible bugs which you can be opened in the issue tracker.

# License

[MIT](LICENSE)
