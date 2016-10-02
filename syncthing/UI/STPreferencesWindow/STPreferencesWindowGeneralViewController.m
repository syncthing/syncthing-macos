//
//  STPreferencesWindowGeneralViewController.m
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

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [self.Syncthing_URI    setStringValue:[defaults objectForKey:@"URI"]];
    [self.Syncthing_ApiKey setStringValue:[defaults objectForKey:@"ApiKey"]];
    [self.StartAtLogin     setStringValue:[defaults objectForKey:@"StartAtLogin"]];
    
    [self updateTestButton];
}

- (void)updateTestButton {
    XGSyncthing *st = [[XGSyncthing alloc] init];
    
    [st setURI:[self.Syncthing_URI stringValue]];
    [st setApiKey:[self.Syncthing_ApiKey stringValue]];
    
    if ([st ping])
        [self.buttonTest setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
    else
        [self.buttonTest setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
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
}

- (IBAction)clickedTest:(id)sender {
    [self updateTestButton];
}

@end
