//
//  STStatusMonitor.h
//  syncthing
//
//  Created by Victor Babenko on 29.06.17.
//  Copyright © 2017 Jerry Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGSyncthing.h"

typedef NS_ENUM(NSInteger, SyncthingStatus) {
    SyncthingStatusOffline,
    SyncthingStatusIdle,
    SyncthingStatusBusy,
    SyncthingStatusError
};

@protocol STStatusMonitorDelegate;

@interface STStatusMonitor : NSObject

@property (nonatomic, strong, readwrite) XGSyncthing *syncthing;
@property (nonatomic) id<STStatusMonitorDelegate> delegate;

- (void) startMonitoring;
- (void) stopMonitoring;

@end

@protocol STStatusMonitorDelegate <NSObject>

- (void)syncMonitorStatusChanged:(SyncthingStatus)status;
- (void)syncMonitorEventReceived:(NSDictionary *)event;

@end
