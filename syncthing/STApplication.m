#import "STApplication.h"
#import "STLoginItem.h"

@interface STAppDelegate ()

@property (nonatomic, strong, readwrite) NSStatusItem *statusItem;
@property (nonatomic, strong, readwrite) XGSyncthing *syncthing;
@property (nonatomic, strong, readwrite) STStatusMonitor *statusMonitor;
@property (weak) IBOutlet NSMenuItem *toggleAllDevicesItem;
@property (strong) STPreferencesWindowController *preferencesWindow;
@property (strong) STAboutWindowController *aboutWindow;
@property (nonatomic, assign) BOOL devicesPaused;

@end

@implementation STAppDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
    _syncthing = [[XGSyncthing alloc] init];
    
    [self applicationLoadConfiguration];
    [_syncthing runExecutable];
    
    _statusMonitor = [[STStatusMonitor alloc] init];
    _statusMonitor.syncthing = _syncthing;
    _statusMonitor.delegate = self;
    [_statusMonitor startMonitoring];
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
    static int configLoadAttempt = 1;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *cfgExecutable = [defaults stringForKey:@"Executable"];
    if (!cfgExecutable) {
        [_syncthing setExecutable:[NSString stringWithFormat:@"%@/%@",
                                   [[NSBundle mainBundle] resourcePath],
                                   @"syncthing/syncthing"]];
    } else {
        [_syncthing setExecutable:cfgExecutable];
    }

    _syncthing.URI = [defaults stringForKey:@"URI"];
    _syncthing.ApiKey = [defaults stringForKey:@"ApiKey"];
    
    // If no values are set, read from XML and store in defaults
    if (!_syncthing.URI.length && !_syncthing.ApiKey.length) {
        BOOL success = [_syncthing loadConfigurationFromXML];
        
        // If XML doesn't exist or is invalid, retry after delay
        if (!success && configLoadAttempt <= 3) {
            configLoadAttempt++;
            [self performSelector:@selector(applicationLoadConfiguration) withObject:self afterDelay:5.0];
            return;
        }
        
        [defaults setObject:_syncthing.URI forKey:@"URI"];
        [defaults setObject:_syncthing.ApiKey forKey:@"ApiKey"];
    }
    
    if (!_syncthing.URI) {
        _syncthing.URI = @"http://localhost:8384";
        [defaults setObject:_syncthing.URI forKey:@"URI"];
    }

    if (!_syncthing.ApiKey) {
        _syncthing.ApiKey = @"";
        [defaults setObject:_syncthing.ApiKey forKey:@"ApiKey"];
    }

    if (![defaults objectForKey:@"StartAtLogin"]) {
        [defaults setBool:[STLoginItem wasAppAddedAsLoginItem] forKey:@"StartAtLogin"];
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

- (void) syncMonitorStatusChanged:(SyncthingStatus)status {
    switch (status) {
        case SyncthingStatusIdle:
            [self updateStatusIcon:@"StatusIconDefault"];
            [_statusItem setToolTip:@"Idle"];
            break;
        case SyncthingStatusBusy:
            [self updateStatusIcon:@"StatusIconSync"];
            [_statusItem setToolTip:@"Syncing"];
            break;
        case SyncthingStatusOffline:
            [_statusItem setToolTip:@"Not connected"];
            [self updateStatusIcon:@"StatusIconNotify"];
            break;
        case SyncthingStatusError:
            [_statusItem setToolTip:@"Error"];
            [self updateStatusIcon:@"StatusIconNotify"];
            break;
    }
}

- (void) syncMonitorEventReceived:(NSDictionary *)event {
    NSNumber *eventId = [event objectForKey:@"id"];
    NSString *eventType = [event objectForKey:@"type"];
    NSDictionary *eventData = [event objectForKey:@"data"];

    if ([eventType isEqualToString:@"ConfigSaved"]) {
        [self refreshDevices];
    }
    else if ([eventType isEqualToString:@"DevicePaused"] ||
        [eventType isEqualToString:@"DeviceResumed"]) {
        [self refreshDevices];
    }
}

- (void)refreshDevices {
    BOOL allPaused = true;
    NSArray *devices = [_syncthing getDevices];
    if (!devices.count)
        return;
    for (NSDictionary *device in devices) {
        NSNumber *paused = device[@"paused"];
        if (paused == nil || paused.boolValue == NO)
            allPaused = false;
    }
    self.devicesPaused = allPaused;
    if (self.devicesPaused)
        self.toggleAllDevicesItem.title = @"Resume All Devices";
    else
        self.toggleAllDevicesItem.title = @"Pause All Devices";
}

- (IBAction) clickedOpen:(id)sender {
    NSURL *URL = [NSURL URLWithString:[_syncthing URI]];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void) updateFoldersMenu:(NSMenu *)menu {
    [menu removeAllItems];
    
    // Get folders from syncthing and sort ascending
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"label" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    NSArray *folders = [[self.syncthing getFolders] sortedArrayUsingDescriptors:@[sort]];

    for (id dir in folders) {
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
    [_statusMonitor stopMonitoring];
    
    [self updateStatusIcon:@"StatusIconNotify"];
    [_statusItem setToolTip:@""];
    _statusItem.menu = nil;
    
    [NSApp performSelector:@selector(terminate:) withObject:nil];
}

- (IBAction)clickedToggleAllDevices:(NSMenuItem *)sender {
    if (self.devicesPaused)
        [_syncthing resumeAllDevices];
    else
        [_syncthing pauseAllDevices];
}

- (IBAction)clickedRescanAll:(NSMenuItem *)sender {
    [_syncthing rescanAll];
}

// TODO: need a more generic approach for opening windows
- (IBAction)clickedPreferences:(NSMenuItem *)sender {
    if (_preferencesWindow != nil) {
        [NSApp activateIgnoringOtherApps:YES];
        [_preferencesWindow.window makeKeyAndOrderFront:self];
        return;
    }
    
    _preferencesWindow = [[STPreferencesWindowController alloc] init];
    [_preferencesWindow showWindow:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:[_preferencesWindow window]];
}

- (IBAction)clickedAbout:(NSMenuItem *)sender {
    if (_aboutWindow != nil) {
        [NSApp activateIgnoringOtherApps:YES];
        [_aboutWindow.window makeKeyAndOrderFront:self];
        return;
    }
    
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
