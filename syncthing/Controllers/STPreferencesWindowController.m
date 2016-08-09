//
//  PreferencesWindowController.m
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesWindowController.h"
#import "STLoginItem.h"
#import "XGSyncthing.h"

@interface STPreferencesWindowController ()

@end

@implementation STPreferencesWindowController

- (id)init {
    return [super initWithWindowNibName:@"STPreferencesWindow"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [super windowDidLoad];
        
    [self.Syncthing_URI    setStringValue:[defaults objectForKey:@"URI"]];
    [self.Syncthing_ApiKey setStringValue:[defaults objectForKey:@"ApiKey"]];
	[self.StartAtLogin     setStringValue:[defaults objectForKey:@"StartAtLogin"]];
}

- (void)updateStartAtLogin:(NSUserDefaults *)defaults {
	STLoginItem *li = [STLoginItem alloc];

	if ([defaults integerForKey:@"StartAtLogin"]) {
		if (![li wasAppAddedAsLoginItem])
			[li addAppAsLoginItem];
	} else {
 		[li deleteAppFromLoginItem];
	}
}

- (IBAction)clickedDone:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[self.Syncthing_URI stringValue] forKey:@"URI"];
    [defaults setObject:[self.Syncthing_ApiKey stringValue] forKey:@"ApiKey"];
	[defaults setObject:[self.StartAtLogin stringValue] forKey:@"StartAtLogin"];
	
	[self updateStartAtLogin:defaults];
	
    [self close];
}

- (IBAction)clickedTest:(id)sender {
	XGSyncthing *st = [[XGSyncthing alloc] init];

	[st setURI:[self.Syncthing_URI stringValue]];
	[st setApiKey:[self.Syncthing_ApiKey stringValue]];

	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	
	[alert setMessageText:@"Syncthing test ping"];
	
	if ([st ping]) {
		[alert setAlertStyle:NSInformationalAlertStyle];
		[alert setInformativeText:@"Ping successfull!"];
	} else {
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert setInformativeText:@"Ping error, URI or API key incorrect?"];
	}
	
	[alert runModal];
}

@end
