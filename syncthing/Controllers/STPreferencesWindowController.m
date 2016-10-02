//
//  PreferencesWindowController.m
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesWindowController.h"

@interface STPreferencesWindowController ()

@end

@implementation STPreferencesWindowController

- (id)init {
    return [super initWithWindowNibName:@"STPreferencesWindow"];
}

- (void)windowDidLoad {
}

- (IBAction)toolbarButtonClicked:(id)sender {
    NSToolbarItem *item = sender;
    [self loadViewWithIdentifier:item.itemIdentifier withAnimation:YES];
}

-(void)loadViewWithIdentifier:(NSString *)viewTabIdentifier
                withAnimation:(BOOL)shouldAnimate{
    /*
    if ([_currentView isEqualToString:viewTabIdentifier]){
        return;
    }
    else
    {
        _currentView = viewTabIdentifier;
    }
     */
    //Loop through the view array and find out the class to load
    
    /*
    NSDictionary *viewInfoDict = nil;
    for (NSDictionary *dict in _toolbarTabsArray){
        if ([dict[@"identifier"] isEqualToString:viewTabIdentifier]){
            viewInfoDict = dict;
            break;
        }
    }
    */
    
    //NSString *class = @"STPreferencesWindowGeneralViewController";//viewInfoDict[@"class"];
    //if(NSClassFromString(class))
    //{
    /*
        _currentViewController = [[STPreferencesWindowGeneralViewController alloc] init];
        
        //Old View
        //NSView * oldView = self.window.contentView;
        
        //self.window.contentView
        
        //New View
        NSView *newView = _currentViewController.view;
        
        NSRect windowRect = self.window.frame;
        NSRect currentViewRect = newView.frame;
    
    
    
        windowRect.origin.y = windowRect.origin.y + (windowRect.size.height - currentViewRect.size.height);
        windowRect.size.height = currentViewRect.size.height;
        windowRect.size.width = currentViewRect.size.width;
    
        [self.window setContentView:newView];
        [self.window setFrame:windowRect display:YES animate:shouldAnimate];
        */
    //} else{
    //    NSAssert(false, @"Couldn't load %@", class);
    //}
}

@end
