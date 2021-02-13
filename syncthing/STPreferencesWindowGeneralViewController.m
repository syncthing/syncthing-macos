//
//  TestView.m
//  syncthing
//
//  Created by Jerry Jacobs on 02/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesWindowGeneralViewController.h"
#import "STLoginItem.h"
#import "XGSyncthing.h"

@interface STPreferencesWindowGeneralViewController ()

@end

@implementation STPreferencesWindowGeneralViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateTestButton];
}

- (id) init {
    self = [super initWithNibName:@"STPreferencesWindowGeneralView" bundle:nil];
    return self;
}

- (void) updateTestButton {
    XGSyncthing *st = [[XGSyncthing alloc] init];
    
    [st setURI:[self.Syncthing_URI stringValue]];
    [st setApiKey:[self.Syncthing_ApiKey stringValue]];
    
    if ([st ping]) {
        [_buttonTest setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
    } else {
        [_buttonTest setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
    }
}

- (IBAction)clickedStartAtLogin:(id)sender {
    [self updateStartAtLogin];
}

- (void) updateStartAtLogin {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"StartAtLogin"]) {
        if (![STLoginItem wasAppAddedAsLoginItem])
            [STLoginItem addAppAsLoginItem];
    } else {
        [STLoginItem deleteAppFromLoginItem];
    }
}

- (IBAction) clickedTest:(id)sender {
    [self updateTestButton];
}

@end
