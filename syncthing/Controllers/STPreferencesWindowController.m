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
    kFoldersView,
    kDevicesView,
    kInfoView,
    kAdvancedView
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
        case kFoldersView:
            if (self.foldersView == nil)
                _foldersView = [[STPreferencesFoldersViewController alloc] init];
            _currentViewController = self.foldersView;
            break;
        case kDevicesView:
            if (self.devicesView == nil)
                _devicesView = [[STPreferencesDevicesViewController alloc] init];
            _currentViewController = self.devicesView;
            break;
        case kInfoView:
            if (self.infoView == nil)
                _infoView = [[STPreferencesInfoViewController alloc] init];
            _currentViewController = self.infoView;
            break;
        case kAdvancedView:
            if (self.advancedView == nil)
                _advancedView = [[STPreferencesAdvancedViewController alloc] init];
            _currentViewController = self.advancedView;
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

/*
 TODO: some day I will know how to dynamic resize the views without
  views window height get broken
 
    //[[self window] setFrame:[currentView bounds] display:YES animate:YES];
 
 // embed the current view to our host view
 //[currentView addSubview:_currentViewController.view];
 
 //[self resizeWindowWithContentSize:_currentViewController.view.frame.size animated:YES];
 //[self.window setContentSize:_currentViewController.view.frame.size];
 //[self setContentView:[_currentViewController view]];
 
 // make sure we automatically resize the controller's view to the current window size
 
 //[self.window setContentSize:_currentViewController.view.frame.size];

- (CGFloat)toolbarHeight {
    NSToolbar *toolbar = [self.window toolbar];
    CGFloat toolbarHeight = 0.0;
    NSRect windowFrame;
    
    if (toolbar && [toolbar isVisible]) {
        windowFrame = [self.window contentRectForFrameRect:self.window.frame
                                            ];
        toolbarHeight = NSHeight(windowFrame) -
        NSHeight([self.window.contentView frame]);
    }
    return toolbarHeight;
}

- (void)resizeToSize:(NSSize)newSize {
    CGFloat newHeight = newSize.height + [self toolbarHeight];
    CGFloat newWidth = newSize.width;
    
    NSRect aFrame = [self.window contentRectForFrameRect:self.window.frame
                                                ];
    
    aFrame.origin.y += aFrame.size.height;
    aFrame.origin.y -= newHeight;
    aFrame.size.height = newHeight;
    aFrame.size.width = newWidth;
    
    aFrame = [self.window frameRectForContentRect:aFrame
                                         ];
    [self.window setFrame:aFrame display:YES animate:YES];
}

- (void) setContentView:(NSView *)view {
    //[self resizeToSize:view.frame.size];
    //[self.window setFrame:view.frame.size display:YES animate:YES];
    [self resizeWindowWithContentSize:view.frame.size animated:YES];
    [self.window setContentView:view];
}
 
- (void) resizeWindowWithContentSize:(NSSize)contentSize animated:(BOOL)animated {
    CGFloat titleBarHeight = self.window.frame.size.height - ((NSView*)self.window.contentView).frame.size.height;
    CGSize windowSize = windowSize = CGSizeMake(contentSize.width, contentSize.height + titleBarHeight);
    
    // Optional: keep it centered
    float originX = self.window.frame.origin.x + (self.window.frame.size.width - windowSize.width) / 2;
    float originY = self.window.frame.origin.y + (self.window.frame.size.height - windowSize.height) / 2;
    NSRect windowFrame = CGRectMake(originX, originY, windowSize.width, windowSize.height);
    
    [self.window setFrame:windowFrame display:YES animate:animated];
}

- (void)resizeWindowForContentSize:(NSSize) size {
    NSWindow *window = [self window];
    
    NSRect windowFrame = [window contentRectForFrameRect:[window frame]];
    NSRect newWindowFrame = [window frameRectForContentRect:
                             NSMakeRect( NSMinX( windowFrame ), NSMaxY( windowFrame ) - size.height, size.width, size.height )];
    [window setFrame:newWindowFrame display:YES animate:[window isVisible]];
}


- (void) setContentView:(NSView *)view {
    
    //NSRect wndFrame = [self.window frameRectForContentRect:[view bounds]];
    
    //NSLog(@"wndFrame: %@", NSStringFromRect(wndFrame));
    //wndFrame.origin.x = self.window.frame.origin.x + (self.window.frame.size.width - view.frame.size.width) / 2;
    //wndFrame.origin.y = self.window.frame.origin.y + (self.window.frame.size.height - view.frame.size.height) / 2;
    
    //[view setFrameOrigin:window.frame.origin];
    [self resizeWindowWithContentSize:view.frame.size animated:YES];
    //[self.window setFrame:wndFrame display:YES animate:YES];
    [[self window] setContentView:view];

    //[[self window] setFrame:newWindowFrame display:YES animate:YES];
    //[[self window] setContentView:view];
}
*/

@end
