//
//  TestView.h
//  syncthing
//
//  Created by Jerry Jacobs on 02/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface STPreferencesWindowGeneralViewController : NSViewController

@property (weak) IBOutlet NSButton *UseProxy;
@property (weak) IBOutlet NSTextField *ProxyURL;
@property (weak) IBOutlet NSTextField *Syncthing_URI;
@property (weak) IBOutlet NSTextField *Syncthing_ApiKey;
@property (weak) IBOutlet NSButton *StartAtLogin;
@property (weak) IBOutlet NSButton *buttonTest;

extern NSNotificationName const STDaemonNeedsRestartNotification;

@end
