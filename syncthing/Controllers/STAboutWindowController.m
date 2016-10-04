//
//  STAboutWindowController.m
//  syncthing
//
//  Created by Jerry Jacobs on 08/08/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sparkle/Sparkle.h>
#import "STAboutWindowController.h"

@interface STAboutWindowController ()

@end

@implementation STAboutWindowController

- (id) init {
	return [super initWithWindowNibName:NSStringFromClass(self.class)];
}

- (void) windowDidLoad {
    [super windowDidLoad];
    [NSApp activateIgnoringOtherApps:YES];
}

-(void) updateControl:(NSTextField*)control withHyperlink:(NSString*)strURL {
	[control setAllowsEditingTextAttributes: YES];
	[control setSelectable: YES];
	
	NSURL* url = [NSURL URLWithString:strURL];
	
	NSAttributedString* attrString = [control attributedStringValue];
	
	NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
	NSRange range = NSMakeRange(0, [attr length]);
	
	[attr addAttribute:NSLinkAttributeName value:url range:range];
	[attr addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range ];
	[attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
	
	[control setAttributedStringValue:attr];
}

- (void) setIcon {
	NSString* appPath = [[NSBundle mainBundle] bundlePath];
	NSImage* appIcon = [[NSWorkspace sharedWorkspace] iconForFile:appPath];
	
	[appIcon setSize:NSMakeSize(64, 64)];
	[_appImageView setImage:appIcon];
}

- (void) awakeFromNib {
	NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];

	[self setIcon];

	_appNameLabel.stringValue = [infoDictionary objectForKey:@"STBundleName"];
	
	_appVersionLabel.stringValue = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	
	[self updateControl:_appHomepageURL withHyperlink:[infoDictionary objectForKey:@"STProjectHomepageURL"]];
}

- (IBAction) clickedCheckForUpdates:(id)sender {
	SUUpdater *updater = [SUUpdater updaterForBundle:[NSBundle mainBundle]];
	[updater checkForUpdates:nil];
	[updater installUpdatesIfAvailable];
}

@end
