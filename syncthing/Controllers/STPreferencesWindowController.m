//
//  PreferencesWindowController.m
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesWindowController.h"

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
}

- (IBAction)clickedOk:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[self.Syncthing_URI stringValue] forKey:@"URI"];
    [defaults setObject:[self.Syncthing_ApiKey stringValue] forKey:@"ApiKey"];
    
    [self close];
}

@end
