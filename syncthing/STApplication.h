//
//  AppDelegate.h
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "XGSyncthing.h"
#import "STStatusMonitor.h"
#import "Controllers/STAboutWindowController.h"
#import "Controllers/STPreferencesWindowController.h"
#import "Syncthing-Swift.h"

@interface STAppDelegate : NSObject <NSApplicationDelegate, STStatusMonitorDelegate, DaemonProcessDelegate>

@property (weak) IBOutlet NSMenu *Menu;
@property (nonatomic, readonly) NSStatusItem *statusItem;

@end
