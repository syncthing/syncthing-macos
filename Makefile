all: debug
debug:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme syncthing
debug-dist:
	mkdir -p Build/Products/Debug/dist
	cp -r Build/Products/Debug/Syncthing.app Build/Products/Debug/dist
debug-dmg:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Debug -scheme syncthing-dmg
release:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme syncthing
release-dmg:
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme Pods-syncthing
	xcodebuild -workspace "syncthing.xcworkspace" -derivedDataPath $(PWD) -configuration Release -scheme syncthing-dmg
update-release:
	$(MAKE) -C cmd/update-release run
clean:
	rm -Rf Build Index Logs ModuleCache.noindex info.plist
