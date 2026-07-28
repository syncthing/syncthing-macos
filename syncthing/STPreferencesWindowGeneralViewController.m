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

NSNotificationName const STDaemonNeedsRestartNotification = @"STDaemonNeedsRestartNotification";

static NSString * const STDaemonQualityOfServiceKey = @"DaemonQualityOfService";
static NSString * const STDaemonQualityOfServiceDefault = @"default";
static NSString * const STDaemonQualityOfServiceUtility = @"utility";
static NSString * const STDaemonQualityOfServiceBackground = @"background";

typedef NS_ENUM(NSInteger, STDaemonQualityOfServiceTag) {
    STDaemonQualityOfServiceTagDefault = 0,
    STDaemonQualityOfServiceTagUtility = 1,
    STDaemonQualityOfServiceTagBackground = 2,
};

@interface STPreferencesWindowGeneralViewController ()

@end

@implementation STPreferencesWindowGeneralViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateProxyControls];
    [self updateDaemonQualityOfServiceControls];
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

- (IBAction)clickedUseProxy:(id)sender {
    [self updateProxyControls];
    [self postDaemonRestartNotification];
}

- (IBAction)proxyUrlChanged:(id)sender {
    [self postDaemonRestartNotification];
}

- (IBAction)clickedDaemonQualityOfService:(NSButton *)sender {
    NSString *qualityOfService = STDaemonQualityOfServiceBackground;

    switch (sender.tag) {
        case STDaemonQualityOfServiceTagDefault:
            qualityOfService = STDaemonQualityOfServiceDefault;
            break;
        case STDaemonQualityOfServiceTagUtility:
            qualityOfService = STDaemonQualityOfServiceUtility;
            break;
        case STDaemonQualityOfServiceTagBackground:
            break;
        default:
            return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:qualityOfService forKey:STDaemonQualityOfServiceKey];
    [self updateDaemonQualityOfServiceControls];
    [self postDaemonRestartNotification];
}

- (void)postDaemonRestartNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:STDaemonNeedsRestartNotification object:self];
}

- (void)updateProxyControls {
    [self.ProxyURL setEnabled:(self.UseProxy.state == NSControlStateValueOn)];
}

- (void)updateDaemonQualityOfServiceControls {
    NSString *qualityOfService = [[NSUserDefaults standardUserDefaults] stringForKey:STDaemonQualityOfServiceKey];
    NSSet<NSString *> *validValues = [NSSet setWithObjects:
        STDaemonQualityOfServiceDefault,
        STDaemonQualityOfServiceUtility,
        STDaemonQualityOfServiceBackground,
        nil];
    if (!qualityOfService || ![validValues containsObject:qualityOfService]) {
        qualityOfService = STDaemonQualityOfServiceBackground;
    }

    self.DaemonQoSDefault.state = [qualityOfService isEqualToString:STDaemonQualityOfServiceDefault]
        ? NSControlStateValueOn : NSControlStateValueOff;
    self.DaemonQoSUtility.state = [qualityOfService isEqualToString:STDaemonQualityOfServiceUtility]
        ? NSControlStateValueOn : NSControlStateValueOff;
    self.DaemonQoSBackground.state = [qualityOfService isEqualToString:STDaemonQualityOfServiceBackground]
        ? NSControlStateValueOn : NSControlStateValueOff;
}

@end
