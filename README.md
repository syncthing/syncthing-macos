# Syncthing for Mac OS X

![stability-beta](https://img.shields.io/badge/stability-beta-yellow.svg)
[![Gratipay Donate](https://img.shields.io/gratipay/user/xor-gate.svg?maxAge=2592000)](https://gratipay.com/~xor-gate)
[![PayPal.Me](https://img.shields.io/badge/donate-PayPal-green.svg?style=flat)](https://paypal.me/xorgate)
[![Downloads](https://img.shields.io/github/downloads/xor-gate/syncthing-macosx/total.svg)](https://github.com/xor-gate/syncthing-macosx/releases) [![Latest release](https://img.shields.io/github/release/xor-gate/syncthing-macosx.svg)](https://github.com/xor-gate/syncthing-macosx/releases/latest) [![Build Status](https://travis-ci.org/xor-gate/syncthing-macosx.svg?branch=master)](https://travis-ci.org/xor-gate/syncthing-macosx) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)

# Introduction

syncthing-macosx is a little tray utility for Syncthing on macOS. It hosts and wraps Syncthing, making it behave more like a native macOS application and less like a command-line utility with a web browser interface.

Features include:
 * Optionally starts on login, so you don't need to set up Syncthing as a service.
 * Tray icon indicates when it is connected to syncthing (no status updates yet).
 * Retina ready icons for the Application bundle and status tray
 * Automatic updates (using [Sparkle](https://sparkle-project.org) pushed from github releases)
 
<img width="562" alt="screen shot 2016-10-05 at 21 24 11" src="https://cloud.githubusercontent.com/assets/1050166/19128366/50d3a3d6-8b43-11e6-8eac-c6cc951193d3.png">

# Installation

Currently Mac OS X 10.10 or higher is necessary. syncthing-macosx is packaged as and disk image with a application bundle.
 You should download the dmg and drag and drop to install. The only necessary configuration is to set the api key which
 can be found in the web interface.

The latest version can be downloaded from [Github Releases](https://github.com/xor-gate/syncthing-macosx/releases/latest)

**NOTE:** As I am not a paid Mac Developer member I have no approved signing keys. It is possible the application is not allowed to run due to the new Apple Application Security Policy (since Mac OS Sierra 10.12). And is already discussed in [issue 8](https://github.com/xor-gate/syncthing-macosx/issues/8#issuecomment-259662447).
 You can soften the policy just for `syncthing-macosx` as described by Apple [Knowledge Base #18657](https://support.apple.com/kb/ph18657).

# Why

All cross-platform approaches are not able to use all the native facilities of Mac OS. Including auto-updates, vector icon set and full packaging.

# Compiling

Build with XCode or run:

```
make debug
```

It will automaticly download syncthing amd64 binary and add it to the Application.

# Contributions

Contributions and issue reports are welcome. I'm an rookie in programming in Objective-C and try to improve over time.
 Please keep in mind I do this on best-effort basis, and I try not to break the auto-updater.

# License

[MIT](LICENSE)
