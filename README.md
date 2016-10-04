# Syncthing for Mac OS X

![stability-beta](https://img.shields.io/badge/stability-beta-yellow.svg)
[![Gratipay Donate](https://img.shields.io/gratipay/user/xor-gate.svg?maxAge=2592000)](https://gratipay.com/~xor-gate)
[![PayPal.Me](https://img.shields.io/badge/donate-PayPal-green.svg?style=flat)](https://paypal.me/xorgate)
[![Downloads](https://img.shields.io/github/downloads/xor-gate/syncthing-macosx/total.svg)](https://github.com/xor-gate/syncthing-macosx/releases) [![Latest release](https://img.shields.io/github/release/xor-gate/syncthing-macosx.svg)](https://github.com/xor-gate/syncthing-macosx/releases/latest) [![Build Status](https://travis-ci.org/xor-gate/syncthing-macosx.svg?branch=master)](https://travis-ci.org/xor-gate/syncthing-macosx) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)

Native systray application for Mac OS X 10.10 and higher.

<img width="401" alt="screen shot 2016-07-15 at 12 33 10" src="https://cloud.githubusercontent.com/assets/1050166/16871829/65a8ceb2-4a89-11e6-8a42-e11be129be5d.png">
<img width="196" alt="screen shot 2016-07-15 at 12 34 07" src="https://cloud.githubusercontent.com/assets/1050166/16871828/65a53b12-4a89-11e6-9318-c8697ee5f72f.png">

* Complete syncthing app package (no need to run syncthing from console)
* Full integration with OSX
* Retina ready icons (pdf)
* Automatic updates using [Sparkle](https://sparkle-project.org) pushed from github releases

# Why

All cross-platform approaches are not able to use all the native facilities of Mac OS. Including auto-updates, vector icon set and full packaging.

# Build

Build with XCode or run:

```
make debug
```

It will automaticly download syncthing amd64 binary and add it to the Application.

# Syncthing ApiKey

You need to configure your API key in the preferences dialog as the application only starts a syncthing instance
 and a system tray. You can fetch your current API key:

`sed -n 's:.*<apikey>\(.*\)</apikey>.*:\1:p' $HOME/Library/Application\ Support/Syncthing/config.xml`

You must restart the application to work (for now).

# Contributions

Contributions are welcome as I'm not an expert in Objective C and Cocoa programming. Feel free to open a issue if you spot a bug or have a feature request.

# License

[MIT](LICENSE)
