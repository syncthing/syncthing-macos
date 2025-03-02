all: debug
debug:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme syncthing
debug-dmg:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme syncthing-dmg
release:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme syncthing
release-dmg:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme syncthing-dmg
release-update:
	source ./venv/bin/activate && ./cmd/update-release.py
clean:
	rm -Rf Build Index Logs ModuleCache.noindex info.plist
