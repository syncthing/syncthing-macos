#!/usr/bin/env python3
#
# Update the Syncthing bundle based on the latest github
# 1. Loads the latest tag name from github api
# 2. Parses the tag
# 3. Writes the syncthing/Info.plist
#
# TODO: also write the new version to syncthing/Scripts/syncthing-resource.sh
###
import json
import semver
import fileinput
from urllib.request import urlopen
from string import Template

distVersion = 1
latest_url = "https://api.github.com/repos/syncthing/syncthing/releases/latest"

response = urlopen(latest_url)
body = response.read().decode("utf-8")
data = json.loads(body)

if 'tag_name' not in data:
	raise ValueError("tag_name not present in latest url")

# Ugly hack because of https://github.com/python-semver/python-semver/issues/137
tag_name = data['tag_name'].replace('v', '')
version = semver.VersionInfo.parse(tag_name)

CFBundleShortVersionString = "{:d}.{:d}.{:d}-{:d}".format(
	version.major,
	version.minor,
	version.patch,
	distVersion)
CFBundleVersion = "{:d}{:03d}{:03d}{:02d}".format(
	version.major,
	version.minor,
	version.patch,
	distVersion)

print(CFBundleShortVersionString)
print(CFBundleVersion)

infoPlistTmpl = {
	'CFBundleShortVersionString' : CFBundleShortVersionString,
	'CFBundleVersion' : CFBundleVersion
}

f = open('syncthing/Info.plist.tmpl', 'r')
tmpl = Template(f.read())
f.close()
result = tmpl.substitute(infoPlistTmpl)

f = open('syncthing/Info.plist', 'w')
f.write(result)
f.close()
