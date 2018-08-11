# Syncthing for macOS

[![Gitter.im Chat](https://img.shields.io/badge/gitter-join%20chat-green.svg)](https://gitter.im/syncthing-macos/Lobby)
[![Downloads](https://img.shields.io/github/downloads/syncthing/syncthing-macos/total.svg)](https://github.com/syncthing/syncthing-macos/releases) [![Latest release](https://img.shields.io/github/release/syncthing/syncthing-macos.svg)](https://github.com/syncthing/syncthing-macos/releases/latest) [![Build Status](https://travis-ci.org/syncthing/syncthing-macos.svg?branch=master)](https://travis-ci.org/syncthing/syncthing-macos) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)

# Introduction

`syncthing-macos` is a native macOS Syncthing tray application bundle. It hosts and wraps [Syncthing](https://syncthing.net), making it behave more like a native macOS application and less like a command-line utility with a web browser interface.

Features include:

 * Open the Syncthing WebGUI from the tray in your prefered browser.
 * Optionally starts on login, so you don't need to set up Syncthing as a service.
 * Tray icon indicates when it is connected to syncthing (no status updates yet).
 * Retina ready icons for the Application bundle and status tray.
 * Automatic updates (using [Sparkle](https://sparkle-project.org) pushed from github releases).
 * Open shared folders directly in Finder.

# Screenshot

<img width="562" alt="screenshot.png" src="https://user-images.githubusercontent.com/1050166/43681636-f2ef6fea-9859-11e8-97f8-88a159b281ba.png">

# Installation

Currently Mac OS X 10.10 or higher is necessary. syncthing-macos is packaged as and disk image with a application bundle.
 You should download the dmg and drag and drop to install. The only necessary configuration is to set the api key which
 can be found in the web interface.

The latest version can be downloaded from [Github Releases](https://github.com/syncthing/syncthing-macos/releases/latest)

Or [homebrew](https://github.com/Homebrew/homebrew-cask) can be used: `brew cask install syncthing-app`

# Why

All cross-platform approaches are not able to use all the native facilities of macOS. Including auto-updates,
 vector icon set (retina-ready) and creating an application bundle. GUIs are designed with XCode and everything
 is coded in Objective-C which is "the native approach".

# Compiling

Build with XCode or run:

```
make debug
```

It will automaticly download syncthing amd64 binary and add it to the Application Bundle.

For release builds signing the application build and creating an distributable DMG:

```
make release-dmg
```

The script will select the first available Developer ID and sign the app with it. To specify the signing identity, use `SYNCTHING_APP_CODE_SIGN_IDENTITY` environment variable:

```
SYNCTHING_APP_CODE_SIGN_IDENTITY="Mac Developer: foo@bar.com (XB59MXU8EC)" make release-dmg
```

# Goal

The goal of this project is to keep the Native macOS Syncthing tray as simple as possible. No graphs, no advanced configuration
 windows. It just provides a very simple wrapper so users are not aware syncthing ships as a commandline application. It strives to have a usability of good-by-default and should always follow the [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos) to feel as much as an native application as possible.

# Known bugs

See the [issue tracker](https://github.com/syncthing/syncthing-macos/issues) for the current status.

# Design

Design, internals and build process is documented in [doc/design.md](doc/design.md)

# Contributions

[Contributions](CONTRIBUTIONS.md) and [issue reports](https://github.com/syncthing/syncthing-macos/issues) are welcome. 

# License

[MIT](LICENSE)
