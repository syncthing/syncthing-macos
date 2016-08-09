all: debug
debug:
	xcodebuild -configuration Debug
release:
	xcodebuild -configuration Release
clean:
	rm -Rf build
