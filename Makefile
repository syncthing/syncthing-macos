all: debug
debug:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme syncthing
release:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme syncthing
release-dmg:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme syncthing-dmg
release-update:
	./cmd/update-release.py
clean:
	rm -Rf Build Index Logs ModuleCache.noindex info.plist
