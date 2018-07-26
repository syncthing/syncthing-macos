package sparkle

import (
	"encoding/xml"
)

type Sparkle struct {
	XMLName xml.Name `xml:"rss"`
	Version string `xml:"version,attr"`
	XMLNSSparkle string `xml:"xmlns:sparkle,attr"`
	XMLNSDC string `xml:"xmlns:dc,attr"`
	Channels []Channel
}

type Channel struct {
	XMLName xml.Name `xml:"channel"`
	Title string `xml:"title"`
	Link string `xml:"link,omitempty"`
	Description string `xml:"description,omitempty"`
	Language string `xml:"language"`
	Items []Item
}

type Item struct {
	XMLName xml.Name `xml:"item"`
	Title string `xml:"title"`
	SparkleReleaseNotesLink string `xml:"sparkle:releaseNotesLink,omitempty"`
	Description CdataString `xml:"description,omitempty"`
	PubDate string `xml:"pubDate"`
	Enclosure Enclosure `xml:"enclosure"`
}

// CdataString for XML CDATA
// See issue: https://github.com/golang/go/issues/16198
type CdataString struct {
	Value string `xml:",cdata"`
}

type Items []Item

type Enclosure struct {
	XMLName xml.Name `xml:enclosure`
	SparkleShortVersionString string `xml:"sparkle:shortVersionString,attr"`
	SparkleVersion string `xml:"sparkle:version,attr"`
	Type string `xml:"type,attr"`
	URL string `xml:"url,attr"`
}

func (s *Sparkle) String() string {
	data, err := xml.MarshalIndent(s, "", "  ")
	if err != nil {
		return ""
	}
	return string(data)
}
