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

@interface STPreferencesWindowController ()

@end

@implementation STPreferencesWindowController

- (id) init {
    return [super initWithWindowNibName:NSStringFromClass(self.class)];
}

- (void) awakeFromNib {
    // NOTE: this should not be needed according to
    //       http://stackoverflow.com/questions/5289386/how-to-give-focus-to-nswindow-loaded-from-nib
    [[self window] setLevel:NSFloatingWindowLevel];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction) toolbarButtonClicked:(id)sender {
    /**
        TODO: load class based on send ID
        NSClassFromString(class)
    */
    NSToolbarItem *button = sender;
    
    if ([self.currentViewController view] != nil)
        [[self.currentViewController view] removeFromSuperview];
    
    if (self.generalView == nil)
        _generalView = [[STPreferencesGeneralViewController alloc] init];
    if (self.foldersView == nil)
        _foldersView = [[STPreferencesFoldersViewController alloc] init];
    if (self.infoView == nil)
        _infoView = [[STPreferencesInfoViewController alloc] init];
    
    switch ([button tag]) {
        case 0:
            _currentViewController = self.generalView;
            break;
        case 1:
            _currentViewController = self.foldersView;
            break;
        // todo devices
        case 2:
            break;
        case 3:
            _currentViewController = self.infoView;
            break;
        default:
            break;
    }
    
    // embed the current view to our host view
    [currentView addSubview:[self.currentViewController view]];
    //[self setContentView:[self.currentViewController view]];
    
    // make sure we automatically resize the controller's view to the current window size
    //[[self.currentViewController view] setFrame:[currentView bounds]];
    
    [[self window] setContentView:_currentViewController.view];
    //[[self window] setFrame:[currentView bounds] display:YES animate:YES];
    
    // set the view controller's represented object to the number of subviews in that controller
    // (our NSTextField's value binding will reflect this value)
    [self.currentViewController setRepresentedObject:[NSNumber numberWithUnsignedInteger:[[[self.currentViewController view] subviews] count]]];
    
    [self didChangeValueForKey:@"viewController"];	// this will trigger the NSTextField's value binding to change
}

- (void) setContentView:(NSView *)view {
    NSRect windowRect = [self window].frame;
    
    windowRect.origin.y    = windowRect.origin.y + (windowRect.size.height - view.frame.size.height);
    windowRect.size.height = view.frame.size.height + 200;
    windowRect.size.width  = view.frame.size.width  + 200;
    
    [[self window] setContentView:view];
    [[self window] setFrame:windowRect display:YES animate:YES];
}

@end
