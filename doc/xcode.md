# XCode tips and tricks

## xcodebuild requires Xcode

```
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

fixed with

```
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```
