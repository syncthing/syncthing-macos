// Github releases to Sparkle Framework appcast.xml converter
package main

import (
	"bytes"
	"context"
	"encoding/xml"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"strconv"
	"strings"
	"time"

	"github.com/google/go-github/github"
	"github.com/hashicorp/go-version"
	"github.com/xor-gate/syncthing-macosx/lib/sparkle"
	"gopkg.in/russross/blackfriday.v2"
)

var githubOrg string
var githubRepo string
var downloadURL string
var appcastURL string
var outFilename string

func init() {
	flag.StringVar(&outFilename, "o", "appcast.xml", "Output filename")
	flag.StringVar(&githubOrg, "github-org", "xor-gate", "Organisation name on github")
	flag.StringVar(&githubRepo, "github-repo", "syncthing-macosx", "Repository name on github")
	flag.StringVar(&downloadURL, "download-url", "https://github.com/xor-gate/syncthing-macosx/releases/download", "Download URL of DMGs")
	flag.StringVar(&appcastURL, "appcast-url", "https://upgrades.xor-gate.org/syncthing-macosx/appcast.xml", "Sparkle appcast.xml URL")
	flag.Parse()
}

func main() {
	// Load github releases
	log.Printf("loading github releases from %s/%s", githubOrg, githubRepo)

	ghclient := github.NewClient(nil)
	releases, _, err := ghclient.Repositories.ListReleases(context.Background(), githubOrg, githubRepo, nil)
	if err != nil {
		log.Fatal(err)
	}

	// Collect Sparkle items
	var items sparkle.Items

	for _, release := range releases {
		item, err := githubRepositoryReleaseToSparkleItem(release)
		if err != nil {
			log.Println("warning:", err)
			continue
		}
		log.Println("added release at", item.Enclosure.URL)
		items = append(items, item)
	}

	// Create the Sparkle appcast.xml
	s := &sparkle.Sparkle{
		Version:      "2.0",
		XMLNSSparkle: "http://www.andymatuschak.org/xml-namespaces/sparkle",
		XMLNSDC:      "http://purl.org/dc/elements/1.1/",
		Channels: []sparkle.Channel{
			sparkle.Channel{
				Title:       "Syncthing for Mac OS X",
				Link:        appcastURL,
				Description: "Most recent changes with links to updates.",
				Language:    "en",
				Items:       items,
			},
		},
	}

	// Write the XML to outFile
	xmlOut := bytes.NewBuffer(nil)
	xmlOut.Write([]byte(xml.Header))
	xw := xml.NewEncoder(xmlOut)
	xw.Encode(s)

	err = ioutil.WriteFile(outFilename, xmlOut.Bytes(), 0755)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("appcast file", outFilename, "successfully written")
	log.Println("appcast.xml url:", appcastURL)
	log.Println("download url:", downloadURL)
}

func githubRepositoryReleaseToSparkleItem(release *github.RepositoryRelease) (sparkle.Item, error) {
	// Decode git tag using semver spec
	rTag := release.GetTagName()
	rVersion, _ := version.NewVersion(rTag)
	rSegments := rVersion.Segments()
	if len(rSegments) != 3 {
		return sparkle.Item{}, fmt.Errorf("git tag '%s' has no 3 semver segments", rTag)
	}

	// Make sure the tags starts with 'v'
	if rTag[0] != 'v' {
		return sparkle.Item{}, fmt.Errorf("git tag '%s' doesn't start with a 'v'", rTag)
	}
	dmgVersion := rTag[1:]

	// Generate CFBundleVersion for Sparkle
	// "v0.14.48-1" -> "144801"
	distVersion, err := strconv.ParseUint(rVersion.Prerelease(), 10, 8)
	if err != nil {
		return sparkle.Item{}, fmt.Errorf("git tag '%s' semver prerelease '%s' is invalid: %v", rTag, rVersion.Prerelease(), err)
	}
	sparkleVersion := fmt.Sprintf("%02d%02d%02d", rSegments[1], rSegments[2], distVersion)

	// Search for dmg in release assets
	var dmgAssetURL string

	for _, asset := range release.Assets {
		url := asset.GetBrowserDownloadURL()
		if !strings.HasSuffix(url, ".dmg") {
			continue
		}
		dmgAssetURL = fmt.Sprintf("%s/%s/Syncthing-%s.dmg", downloadURL, rTag, dmgVersion)
	}

	if dmgAssetURL == "" {
		return sparkle.Item{}, fmt.Errorf("no dmg found for release %s", rTag)
	}

	// Translate github Markdown description to HTML and add the item to the list
	htmlDescription := string(blackfriday.Run([]byte(release.GetBody())))

	item := sparkle.Item{
		Title:       release.GetName(),
		PubDate:     release.PublishedAt.Format(time.RFC1123),
		Description: sparkle.CdataString{Value: htmlDescription},
		Enclosure: sparkle.Enclosure{
			SparkleShortVersionString: rTag,
			SparkleVersion:            sparkleVersion,
			URL:                       dmgAssetURL,
			Type:                      "application/octet-stream",
		},
	}

	return item, nil
}
