//
//  PreferencesWindowController.h
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STPreferencesGeneralViewController;

@interface STPreferencesWindowController : NSWindowController
{
    IBOutlet NSView *currentView;
}

@property (nonatomic, assign) NSViewController *currentViewController;
@property (nonatomic, strong) STPreferencesGeneralViewController *generalView;

- (IBAction) toolbarButtonClicked:(id)sender;

@end
