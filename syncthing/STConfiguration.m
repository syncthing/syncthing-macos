//
//  STConfiguration.m
//  syncthing
//
//  Created by Jerry Jacobs on 04/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STConfiguration.h"
#import "XGSyncthing.h"

@interface STConfiguration()

@property XGSyncthing *st;

@end

@implementation STConfiguration

NSString *const defaultHost       = @"http://localhost:8384";
NSString *defaultExecutable;

- (id) init {
    defaultExecutable = [NSString stringWithFormat:@"%@/%@",
                         [[NSBundle mainBundle] resourcePath],
                         @"syncthing/syncthing"];
    return self;
}

- (void)saveConfig {
    
}

- (void)loadConfig {
    
}

@end
