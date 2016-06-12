//
//  PreferencesWindowController.h
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface STPreferencesWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *Syncthing_URI;
@property (weak) IBOutlet NSTextField *Syncthing_ApiKey;

@end