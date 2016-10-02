//
//  PreferencesWindowController.m
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesWindowController.h"
#import "STPreferencesWindowGeneralViewController.h"

@interface STPreferencesWindowController ()

@end

@implementation STPreferencesWindowController

- (id)init {
    return [super initWithWindowNibName:NSStringFromClass(self.class)];
}

- (void)awakeFromNib {
    [[self window] setLevel:NSFloatingWindowLevel];
}

- (IBAction)toolbarButtonClicked:(id)sender {
    /**
        TODO: load class based on send ID
        NSClassFromString(class)
    */
    NSRect frameRect = NSMakeRect(0, 0 , 320, 320);
    NSView *tmpView  = [[NSView alloc] initWithFrame:frameRect];
    
    [self setContentView:tmpView];
}

- (void)setContentView:(NSView *)view {
    NSRect windowRect = [self window].frame;
    
    windowRect.origin.y = windowRect.origin.y + (windowRect.size.height - view.frame.size.height);
    windowRect.size.height = view.frame.size.height;
    windowRect.size.width = view.frame.size.width;
    
    [[self window] setContentView:view];
    [[self window] setFrame:windowRect display:YES animate:YES];
}

@end
