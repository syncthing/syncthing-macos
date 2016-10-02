//
//  TestView.m
//  syncthing
//
//  Created by Jerry Jacobs on 02/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesGeneralViewController.h"
#import "STLoginItem.h"
#import "XGSyncthing.h"

@interface STPreferencesGeneralViewController ()

@end

@implementation STPreferencesGeneralViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [_Syncthing_URI    setStringValue:[defaults objectForKey:@"URI"]];
    [_Syncthing_ApiKey setStringValue:[defaults objectForKey:@"ApiKey"]];
    [_StartAtLogin     setStringValue:[defaults objectForKey:@"StartAtLogin"]];
    
    [self updateTestButton];
    [_buttonSave setEnabled:NO];
}

- (id) init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    return self;
}

- (void) updateTestButton {
    XGSyncthing *st = [[XGSyncthing alloc] init];
    
    [st setURI:[self.Syncthing_URI stringValue]];
    [st setApiKey:[self.Syncthing_ApiKey stringValue]];
    
    if ([st ping]) {
        [_buttonSave setEnabled:YES];
        [_buttonTest setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
    } else {
        [_buttonSave setEnabled:NO];
        [_buttonTest setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
    }
}

- (void) updateStartAtLogin:(NSUserDefaults *)defaults {
    STLoginItem *li = [STLoginItem alloc];
    
    if ([defaults integerForKey:@"StartAtLogin"]) {
        if (![li wasAppAddedAsLoginItem])
            [li addAppAsLoginItem];
    } else {
        [li deleteAppFromLoginItem];
    }
}

- (IBAction) clickedSave:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[_Syncthing_URI stringValue] forKey:@"URI"];
    [defaults setObject:[_Syncthing_ApiKey stringValue] forKey:@"ApiKey"];
    [defaults setObject:[_StartAtLogin stringValue] forKey:@"StartAtLogin"];
    
    [self updateStartAtLogin:defaults];
    [_buttonSave setEnabled:NO];
}

- (IBAction) clickedTest:(id)sender {
    [self updateTestButton];
}

@end
