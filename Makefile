all: debug
debug:
	xcodebuild -derivedDataPath $(PWD) -configuration Debug -scheme syncthing
release:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme syncthing
	xcodebuild build -derivedDataPath $(PWD) -configuration Release -scheme syncthing
clean:
	rm -Rf Build
