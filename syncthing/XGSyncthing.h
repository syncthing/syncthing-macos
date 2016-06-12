/**
 * Syncthing Objective-C client library
 */
#import <Foundation/Foundation.h>

@interface XGSyncthing : NSObject {}

@property (nonatomic, copy) NSString *Executable;
@property (nonatomic, copy) NSString *URI;
@property (nonatomic, copy) NSString *ApiKey;

/**
 * Run the syncthing executable
 * E.g from Syncthing.app/MacOS/Resources/syncthing/syncthing: 
 *  "[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"syncthing/syncthing"]"
 */
- (bool)runExecutable;
// Interrupts syncthing and block-waits until exit
- (void)stopExecutable;


- (bool)ping;
- (id)getUptime;

@end