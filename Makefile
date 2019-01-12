all: debug
debug:
	xcodebuild -derivedDataPath $(PWD) -configuration Debug -scheme syncthing
release:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme syncthing
release-dmg:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme syncthing-dmg
clean:
	rm -Rf Build Index Logs ModuleCache.noindex info.plist
