//
//  LoginItem.h
//  syncthing
//
//  Created by Jerry Jacobs on 16/07/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#ifndef LoginItem_h
#define LoginItem_h

#include <Foundation/Foundation.h>

@interface STLoginItem : NSObject

+ (void) addAppAsLoginItem;
+ (BOOL) wasAppAddedAsLoginItem;
+ (void) deleteAppFromLoginItem;

@end

#endif /* LoginItem_h */
