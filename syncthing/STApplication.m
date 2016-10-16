#import "STApplication.h"

@interface STAppDelegate ()

@property (nonatomic, strong, readwrite) NSStatusItem *statusItem;
@property (nonatomic, strong, readwrite) NSTimer *updateTimer;
@property (nonatomic, strong, readwrite) XGSyncthing *syncthing;
@property (strong) STPreferencesWindowController *preferencesWindow;
@property (strong) STAboutWindowController *aboutWindow;

@end

@implementation STAppDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
    _syncthing = [[XGSyncthing alloc] init];
    
    [self applicationLoadConfiguration];
    [_syncthing loadConfigurationFromXML];
    [_syncthing runExecutable];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateStatusFromTimer) userInfo:nil repeats:YES];
}

- (void) clickedFolder:(id)sender {
    NSString *path = [sender representedObject];
    [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:@""];
}

- (void) applicationWillTerminate:(NSNotification *)aNotification {
    // TODO: is this needed -> remove?
}

- (void) awakeFromNib {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.menu = _Menu;
    
    [self updateStatusIcon:@"StatusIconNotify"];
}

// TODO: move to STConfiguration class
- (void)applicationLoadConfiguration {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *cfgExecutable = [defaults stringForKey:@"Executable"];
    if (!cfgExecutable) {
        [_syncthing setExecutable:[NSString stringWithFormat:@"%@/%@",
                                   [[NSBundle mainBundle] resourcePath],
                                   @"syncthing/syncthing"]];
    } else {
        [_syncthing setExecutable:cfgExecutable];
    }

    NSString *cfgURI = [defaults stringForKey:@"URI"];
    if (!cfgURI) {
        [_syncthing setURI:@"http://localhost:8384"];
        [defaults setObject:[_syncthing URI] forKey:@"URI"];
    } else {
        [_syncthing setURI:cfgURI];
    }

    NSString *cfgApiKey = [defaults stringForKey:@"ApiKey"];
    if (!cfgApiKey) {
        [_syncthing setApiKey:@""];
        [defaults setObject:[_syncthing ApiKey] forKey:@"ApiKey"];
    } else {
        [_syncthing setApiKey:cfgApiKey];
    }

    NSString *cfgStartAtLogin = [defaults stringForKey:@"StartAtLogin"];
    if (!cfgStartAtLogin) {
        [defaults setObject:@"false" forKey:@"StartAtLogin"];
    }
}

- (void) sendNotification:(NSString *)text {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Syncthing";
    notification.informativeText = text;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void) updateStatusIcon:(NSString *)icon {
	_statusItem.button.image = [NSImage imageNamed:icon];
	[_statusItem.button.image setTemplate:YES];
}

- (void) updateStatusFromTimer {
    if ([_syncthing ping]) {
        [self updateStatusIcon:@"StatusIconDefault"];
        [_statusItem setToolTip:@"Connected"];
    } else {
        [self updateStatusIcon:@"StatusIconNotify"];
        [_statusItem setToolTip:@"Not connected"];
    }
}

- (IBAction) clickedOpen:(id)sender {
    NSURL *URL = [NSURL URLWithString:[_syncthing URI]];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void) updateFoldersMenu:(NSMenu *)menu {
    [menu removeAllItems];
    
    for (id dir in [self.syncthing getFolders]) {
        NSString *name = [dir objectForKey:@"label"];
        if ([name length] == 0)
            name = [dir objectForKey:@"id"];
        
        NSMenuItem *item = [[NSMenuItem alloc] init];
        
        [item setTitle:name];
        [item setRepresentedObject:[dir objectForKey:@"path"]];
        [item setAction:@selector(clickedFolder:)];
        [item setToolTip:[dir objectForKey:@"path"]];
        
        [menu addItem:item];
    }
}

-(void) menuWillOpen:(NSMenu *)menu {
	if ([[menu title] isEqualToString:@"Folders"])
        [self updateFoldersMenu:menu];
}

- (IBAction) clickedQuit:(id)sender {
    [_syncthing stopExecutable];
    
    [_updateTimer invalidate];
    _updateTimer = nil;
    
    [self updateStatusIcon:@"StatusIconNotify"];
    [_statusItem setToolTip:@""];
    _statusItem.menu = nil;
    
    [NSApp performSelector:@selector(terminate:) withObject:nil];
}

// TODO: need a more generic approach for opening windows
- (IBAction)clickedPreferences:(NSMenuItem *)sender {
    _preferencesWindow = [[STPreferencesWindowController alloc] init];
    [_preferencesWindow showWindow:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:[_preferencesWindow window]];
}

- (IBAction)clickedAbout:(NSMenuItem *)sender {
	_aboutWindow = [[STAboutWindowController alloc] init];
	[_aboutWindow showWindow:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(aboutWillClose:)
												 name:NSWindowWillCloseNotification
											   object:[_aboutWindow window]];
}

// TODO: need a more generic approach for closing windows
- (void)aboutWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowWillCloseNotification
                                                  object:[_aboutWindow window]];
    _aboutWindow = nil;
}

- (void)preferencesWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowWillCloseNotification
                                                  object:[_preferencesWindow window]];
    _preferencesWindow = nil;
}

@end
