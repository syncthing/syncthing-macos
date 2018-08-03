/**
 * Syncthing Objective-C client library
 */
#import <Foundation/Foundation.h>

@interface XGSyncthing : NSObject<NSXMLParserDelegate>

@property (nonatomic, copy) NSString *URI;
@property (nonatomic, copy) NSString *ApiKey;

- (bool)ping;
- (id)getUptime;
- (id)getMyID;
- (NSDictionary *)getConfig;
- (id)getFolders;
- (NSArray *)getDevices;
- (void)pauseAllDevices;
- (void)resumeAllDevices;
- (void)rescanAll;
- (id)getEventsSince:(long)since;

/**
 * Load configuration from XML file
 */
- (BOOL)loadConfigurationFromXML;

@end
