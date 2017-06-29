//
//  STStatusMonitor.h
//  syncthing
//
//  Created by Victor Babenko on 29.06.17.
//  Copyright © 2017 Jerry Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SyncthingStatus) {
    SyncthingStatusIdle,
    SyncthingStatusBusy,
    SyncthingStatusError
};

@protocol STStatusMonitorDelegate;

@interface STStatusMonitor : NSObject

@property (nonatomic, copy) NSString *URI;
@property (nonatomic, copy) NSString *ApiKey;
@property (nonatomic) id<STStatusMonitorDelegate> delegate;

- (void) startMonitoring;
- (void) stopMonitoring;

@end

@protocol STStatusMonitorDelegate <NSObject>

- (void)syncMonitorStatusChanged:(SyncthingStatus)status;

@end
