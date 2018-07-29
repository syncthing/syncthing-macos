//
//  LocalhostTLSDelegate.m
//  syncthing
//
//  Created by Jakob Borg on 2018-07-28.
//  Copyright © 2018 Jerry Jacobs. All rights reserved.
//

#import "LocalhostTLSDelegate.h"

@implementation LocalhostTLSDelegate

- (void) URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if (challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodServerTrust) {
        // We're doing something other than checking a server certificate.
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        return;
    }

    if ([challenge.protectionSpace.host isEqualToString:@"localhost"] ||
        [challenge.protectionSpace.host isEqualToString:@"127.0.0.1"] ||
        [challenge.protectionSpace.host isEqualToString:@"::1"]) {
        // We're looking at localhost. Accept any certificate.
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        return;
    }

    // Perform the default processing.
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

@end
