# Syncthing for Mac OS X

[![PayPal.Me](https://img.shields.io/badge/donate-PayPal-green.svg?style=flat)](https://paypal.me/xorgate) [![Downloads](https://img.shields.io/github/downloads/xor-gate/syncthing-macosx/total.svg)](https://github.com/xor-gate/syncthing-macosx/releases) [![Latest release](https://img.shields.io/github/release/xor-gate/syncthing-macosx.svg)](https://github.com/xor-gate/syncthing-macosx/releases/latest) [![Build Status](https://travis-ci.org/xor-gate/syncthing-macosx.svg?branch=master)](https://travis-ci.org/xor-gate/syncthing-macosx) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)

# Build

```
xcodebuild
```

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

# License

[MIT](LICENSE)