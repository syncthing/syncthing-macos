#import "STApplication.h"
#import "STLoginItem.h"
#import "Syncthing-Swift.h"

@interface STAppDelegate ()

@property (nonatomic, strong, readwrite) NSStatusItem *statusItem;
@property (nonatomic, strong, readwrite) XGSyncthing *syncthing;
@property (nonatomic, strong, readwrite) NSString *executable;
@property (nonatomic, strong, readwrite) DaemonProcess *process;
@property (nonatomic, strong, readwrite) STStatusMonitor *statusMonitor;
@property (weak) IBOutlet NSMenuItem *toggleAllDevicesItem;
@property (weak) IBOutlet NSMenuItem *statusMenuItem;
@property (weak) IBOutlet NSMenuItem *connectionStatusMenuItem;
@property (weak) IBOutlet NSMenuItem *daemonStatusMenuItem;
@property (weak) IBOutlet NSMenuItem *daemonStartMenuItem;
@property (weak) IBOutlet NSMenuItem *daemonStopMenuItem;
@property (weak) IBOutlet NSMenuItem *daemonRestartMenuItem;
@property (strong) STPreferencesWindowController *preferencesWindow;
@property (strong) STAboutWindowController *aboutWindow;
@property (nonatomic, assign) BOOL devicesPaused;
@property (nonatomic, assign) BOOL daemonOK;
@property (nonatomic, assign) BOOL connectionOK;

@end

@implementation STAppDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
    _syncthing = [[XGSyncthing alloc] init];

    [self applicationLoadConfiguration];

    _process = [[DaemonProcess alloc] initWithPath:_executable delegate:self];
    [_process launch];

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
    [_process terminate];
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

    _executable = [defaults stringForKey:@"Executable"];
    if (!_executable) {
        // We store the executable in ~/Library/Application Support/Syncthing-macOS/syncthing by default
        _executable = [[self applicationSupportDirectoryFor:@"Syncthing-macOS"] stringByAppendingPathComponent:@"syncthing"];
        [defaults setValue:_executable forKey:@"Executable"];
    }

    NSError *error;
    if (![self ensureExecutableAt:_executable error:&error]) {
        // Fail :(
        // TODO(jb): We should show a proper error dialog here.
        NSLog(@"Failed to prepare binary: %@", [error localizedDescription]);
        return;
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

- (NSString*)applicationSupportDirectoryFor:(NSString*)application {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        return [[paths firstObject] stringByAppendingPathComponent:application];
}

- (BOOL)ensureExecutableAt:(NSString*)path error:(NSError* _Nullable*)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        // The executable exists. Nothing for us to do.
        return YES;
    }

    NSString *parent = [path stringByDeletingLastPathComponent];
    if (![manager fileExistsAtPath:path]) {
        // The directory to hold the binary doesn't exist. We must create it.
        if (![manager createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:error]) {
            return NO;
        }
    }

    // Copy the bundled executable to the desired location. Pass on return and error to the caller.
    NSString *bundled = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"syncthing/syncthing"];
    return [manager copyItemAtPath:bundled toPath:path error:error];
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
            [self updateConnectionStatus:true];
            break;
        case SyncthingStatusBusy:
            [self updateStatusIcon:@"StatusIconSync"];
            [_statusItem setToolTip:@"Syncing"];
            [self updateConnectionStatus:true];
            break;
        case SyncthingStatusOffline:
            [_statusItem setToolTip:@"Not connected"];
            [self updateStatusIcon:@"StatusIconNotify"];
            [self updateConnectionStatus:false];
            break;
        case SyncthingStatusError:
            [_statusItem setToolTip:@"Error"];
            [self updateStatusIcon:@"StatusIconNotify"];
            [self updateConnectionStatus:false]; // XXX: Maybe? Or what does it mean
            break;
    }
}

- (void) syncMonitorEventReceived:(NSDictionary *)event {
    NSString *eventType = [event objectForKey:@"type"];

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

- (IBAction)clickedDaemonStart:(NSMenuItem *)sender {
    [_process launch];
}

- (IBAction)clickedDaemonStop:(NSMenuItem *)sender {
    [_process terminate];
}

- (IBAction)clickedDaemonRestart:(NSMenuItem *)sender {
    [_process restart];
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

- (void)process:(DaemonProcess *)_ isRunning:(BOOL)isRunning {
    if (_daemonOK == isRunning) {
        return;
    }
    _daemonOK = isRunning;
    if (_daemonOK) {
        [_daemonStatusMenuItem setTitle:@"Syncthing Service (Running)"];
        [_daemonStatusMenuItem setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
        [_daemonStartMenuItem setEnabled:NO];
        [_daemonStopMenuItem setEnabled:YES];
        [_daemonRestartMenuItem setEnabled:YES];
    } else {
        [_daemonStatusMenuItem setTitle:@"Syncthing Service (Stopped)"];
        [_daemonStatusMenuItem setImage:[NSImage imageNamed:@"NSStatusUnavailable"]];
        [_daemonStartMenuItem setEnabled:YES];
        [_daemonStopMenuItem setEnabled:NO];
        [_daemonRestartMenuItem setEnabled:NO];
    }

    [self updateAggregateState];
}

- (void)updateConnectionStatus:(BOOL)isConnected {
    if (_connectionOK == isConnected) {
        return;
    }
    _connectionOK = isConnected;
    if (_connectionOK) {
        [_connectionStatusMenuItem setTitle:@"API (Online)"];
        [_connectionStatusMenuItem setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    } else {
        [_connectionStatusMenuItem setTitle:@"API (Offline)"];
        [_connectionStatusMenuItem setImage:[NSImage imageNamed:@"NSStatusUnavailable"]];
    }

    [self updateAggregateState];
}

- (void)updateAggregateState {
    if (_daemonOK) {
        if (_connectionOK) {
            [_statusMenuItem setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
            [_statusMenuItem setTitle:@"Online"];
        } else {
            [_statusMenuItem setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
            [_statusMenuItem setTitle:@"Running (Offline)"];
        }
    } else {
        if (_connectionOK) {
            [_statusMenuItem setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
            [_statusMenuItem setTitle:@"Unknown (Online)"];
        } else {
            [_statusMenuItem setImage:[NSImage imageNamed:@"NSStatusUnavailable"]];
            [_statusMenuItem setTitle:@"Unavailable"];
        }
    }
}

@end
