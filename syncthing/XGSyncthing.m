#import "XGSyncthing.h"

@interface XGSyncthing()

@property NSTask *StTask;

@end

@implementation XGSyncthing {}

@synthesize Executable = _Executable;
@synthesize URI = _URI;
@synthesize ApiKey = _apiKey;

- (bool) runExecutable
{
    self.StTask = [[NSTask alloc] init];
    
    [_StTask setLaunchPath:_Executable];
    [_StTask setQualityOfService:NSQualityOfServiceBackground];
    [_StTask launch];

    return true;
}

- (void) stopExecutable
{
    if (!_StTask)
        return;
    
    [_StTask interrupt];
    [_StTask waitUntilExit];
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

- (id) getMyID {
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
    
    return [json objectForKey:@"myID"];
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
