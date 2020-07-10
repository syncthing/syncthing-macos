//
//  PreferencesWindowController.m
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesWindowController.h"
#import "STPreferencesGeneralViewController.h"
#import "STPreferencesFoldersViewController.h"
#import "STPreferencesInfoViewController.h"
#import "STPreferencesDevicesViewController.h"
#import "STPreferencesAdvancedViewController.h"

@interface STPreferencesWindowController ()

@end

@implementation STPreferencesWindowController

enum
{
    kGeneralView = 0,
};

- (id) init {
    return [super initWithWindowNibName:NSStringFromClass(self.class)];
}

- (void) awakeFromNib {
    [self setViewFromId:kGeneralView];
}

- (void) windowDidLoad {
    [super windowDidLoad];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void) setViewFromId:(NSInteger) tag {
    if ([_currentViewController view] != nil)
        [[_currentViewController view] removeFromSuperview];
    
    switch (tag) {
        case kGeneralView:
            if (self.generalView == nil)
                _generalView = [[STPreferencesGeneralViewController alloc] init];
            _currentViewController = self.generalView;
            break;
        default:
            break;
    }
    
    [[self window] setContentView:[_currentViewController view]];
    
    // set the view controller's represented object to the number of subviews in that controller
    // (our NSTextField's value binding will reflect this value)
    [self.currentViewController setRepresentedObject:[NSNumber numberWithUnsignedInteger:[[_currentViewController.view subviews] count]]];

    // this will trigger the NSTextField's value binding to change
    [self didChangeValueForKey:@"viewController"];
}

- (IBAction) toolbarButtonClicked:(id)sender {
    NSToolbarItem *button = sender;
    [self setViewFromId:[button tag]];
}

@end
