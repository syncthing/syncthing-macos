#import "XGSyncthing.h"

@interface XGSyncthing()

@property NSTask *_StTask;

@end

@implementation XGSyncthing {}

@synthesize Executable = _Executable;
@synthesize URI = _URI;
@synthesize ApiKey = _apiKey;

- (bool)runExecutable
{
    self._StTask = [[NSTask alloc] init];
    [self._StTask setLaunchPath:_Executable];
    [self._StTask setQualityOfService:NSQualityOfServiceBackground];
    [self._StTask launch];
    return true;
}

- (void)stopExecutable
{
    if (!self._StTask)
        return;
    
    [self._StTask interrupt];
    [self._StTask waitUntilExit];
}

- (bool)ping
{
	NSData *serverData = nil;
	NSError *myError = nil;
	NSURLResponse *serverResponse = nil;
	NSMutableURLRequest *theRequest=[NSMutableURLRequest
	 requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _URI, @"/rest/system/ping"]]
	 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setValue:_apiKey forHTTPHeaderField:@"X-API-Key"];
    
	serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                       returningResponse:&serverResponse error:&myError];

    if (myError)
        return false;
    
	id json = [NSJSONSerialization JSONObjectWithData:serverData options:
		NSJSONReadingMutableContainers error:&myError];

	if ([[json objectForKey:@"ping"] isEqualToString:@"pong"])
		return true;
	return false;
}

- (id)getUptime
{
    NSData *serverData = nil;
    NSError *myError = nil;
    NSURLResponse *serverResponse = nil;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _URI, @"/rest/system/status"]]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setValue:_apiKey forHTTPHeaderField:@"X-API-Key"];
    
    serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                       returningResponse:&serverResponse error:&myError];
    
    if (myError)
        return false;
    
    id json = [NSJSONSerialization JSONObjectWithData:serverData options:
               NSJSONReadingMutableContainers error:&myError];
    
    return [json objectForKey:@"uptime"];
}

- (id)getFolders
{
    NSData *serverData = nil;
    NSError *myError = nil;
    NSURLResponse *serverResponse = nil;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _URI, @"/rest/system/config"]]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setValue:_apiKey forHTTPHeaderField:@"X-API-Key"];
    
    serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                       returningResponse:&serverResponse error:&myError];
    
    if (myError)
        return nil;
    
    id json = [NSJSONSerialization JSONObjectWithData:serverData options:
               NSJSONReadingMutableContainers error:&myError];
    
    return [json objectForKey:@"folders"];
}


@end
