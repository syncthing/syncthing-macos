//
//  STStatusMonitor.m
//  syncthing
//
//  Created by Victor Babenko on 29.06.17.
//  Copyright © 2017 Jerry Jacobs. All rights reserved.
//

#import "STStatusMonitor.h"

@interface STStatusMonitor ()

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) long lastSeenId;
@property (nonatomic) NSMutableDictionary *folderStates;
@property (nonatomic, assign) SyncthingStatus currentStatus;
@property (nonatomic, strong, readwrite) NSTimer *updateTimer;

@end

@implementation STStatusMonitor

- (instancetype)init {
    self = [super init];
    
    self.folderStates = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void) longPoll {
    @autoreleasepool {
        NSString *url = nil;
        
        if (self.lastSeenId) {
            url = [NSString stringWithFormat:@"%@%@%ld", self.syncthing.URI, @"/rest/events?since=", self.lastSeenId];
        }
        else {
            url = [NSString stringWithFormat:@"%@%@", self.syncthing.URI, @"/rest/events?limit=1"];
        }
        
        NSData *serverData = nil;
        NSError *myError = nil;
        NSURLResponse *serverResponse = nil;
        NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                         requestWithURL:[NSURL URLWithString:url]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        [theRequest setHTTPMethod:@"GET"];
        [theRequest setValue:self.syncthing.ApiKey forHTTPHeaderField:@"X-API-Key"];
        
        serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                           returningResponse:&serverResponse error:&myError];
        
        if (!myError) {
            id json = [NSJSONSerialization JSONObjectWithData:serverData options:
                       NSJSONReadingMutableContainers error:&myError];
            
            
            [self performSelectorOnMainThread:@selector(dataReceived:)
                                   withObject:json waitUntilDone:YES];
        }
        else if ([[myError domain] isEqualToString:@"NSURLErrorDomain"] && [myError code] != NSURLErrorTimedOut) {
            self.lastSeenId = 0;
            [NSThread sleepForTimeInterval:1.0];
        }
    }
    
    if (self.enabled)
        [self performSelectorInBackground:@selector(longPoll) withObject: nil];
}

- (void) dataReceived: (id) data {
    if ([data isKindOfClass:[NSArray class]]) {
        for (NSDictionary *event in data) {
            [self processEvent:event];
        }
    }
}

- (void) processEvent:(NSDictionary *)event {
    NSNumber *eventId = [event objectForKey:@"id"];
    NSString *eventType = [event objectForKey:@"type"];
    NSDictionary *eventData = [event objectForKey:@"data"];
    
    self.lastSeenId = [eventId longValue];
    if ([eventType isEqualToString:@"StateChanged"]) {
        NSString *folder = [eventData objectForKey:@"folder"];
        NSString *newState = [eventData objectForKey:@"to"];
        
        self.folderStates[folder] = newState;
        [self updateCurrentStatus];
    }
}

- (void) updateStatusFromTimer {
    if (![_syncthing ping]) {
        self.currentStatus = SyncthingStatusOffline;
    }
    else if (self.currentStatus == SyncthingStatusOffline) {
        self.currentStatus = SyncthingStatusIdle;
    }
}

- (void) updateCurrentStatus {
    SyncthingStatus newStatus = SyncthingStatusIdle;
    for (NSString *key in self.folderStates) {
        NSString *state = self.folderStates[key];
        if (newStatus != SyncthingStatusError) {
            if ([state isEqualToString:@"scanning"] || [state isEqualToString:@"syncing"])
                newStatus = SyncthingStatusBusy;
            else if ([state isEqualToString:@"error"])
                newStatus = SyncthingStatusError;
        }
    }
    self.currentStatus = newStatus;
}

- (void)setCurrentStatus:(SyncthingStatus)newStatus {
    if (_currentStatus != newStatus) {
        [self.delegate syncMonitorStatusChanged:newStatus];
    }
    _currentStatus = newStatus;
}

- (void) startMonitoring {
    if (!self.enabled) {
        self.enabled = YES;
        [self performSelectorInBackground:@selector(longPoll) withObject: nil];
        
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateStatusFromTimer) userInfo:nil repeats:YES];
    }
}

- (void) stopMonitoring {
    self.enabled = NO;
    [_updateTimer invalidate];
    _updateTimer = nil;
}

@end
