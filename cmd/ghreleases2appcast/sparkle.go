package main

import (
	"encoding/xml"
)

type Sparkle struct {
	XMLName xml.Name `xml:"rss"`
	Version string `xml:"version,attr"`
	XMLNSSparkle string `xml:"xmlns:sparkle,attr"`
	XMLNSDC string `xml:"xmlns:dc,attr"`
	Channels []SparkleChannel
}

type SparkleChannel struct {
	XMLName xml.Name `xml:"channel"`
	Title string `xml:"title"`
	Link string `xml:"link,omitempty"`
	Description string `xml:"description,omitempty"`
	Language string `xml:"language"`
	Items []SparkleItem
}

type SparkleItem struct {
	XMLName xml.Name `xml:"item"`
	Title string `xml:"title"`
	SparkleReleaseNotesLink string `xml:"sparkle:releaseNotesLink,omitempty"`
	Description SparkleCdataString `xml:"description,omitempty"`
	PubDate string `xml:"pubDate"`
	Enclosure SparkleEnclosure `xml:"enclosure"`
}

// CdataString for XML CDATA
// See issue: https://github.com/golang/go/issues/16198
type SparkleCdataString struct {
	Value string `xml:",cdata"`
}

type SparkleItems []SparkleItem

type SparkleEnclosure struct {
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
