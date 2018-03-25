#import "XGSyncthing.h"

@interface XGSyncthing()

@property NSTask *StTask;
@property (nonatomic, strong) NSXMLParser *configParser;
@property (nonatomic, strong) NSMutableArray<NSString *> *parsing;

@end

@implementation XGSyncthing {}

@synthesize Executable = _Executable;
@synthesize URI = _URI;
@synthesize ApiKey = _apiKey;

- (bool) runExecutable
{
    _StTask = [[NSTask alloc] init];
    
    [_StTask setLaunchPath:_Executable];
    [_StTask setArguments:@[@"-no-browser"]];
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

- (id)sendRequestToEndpoint:(NSString *)endpoint method:(NSString *)method parameters:(NSDictionary *)parameters
{
    NSData *serverData = nil;
    NSError *myError = nil;
    NSURLResponse *serverResponse = nil;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _URI, endpoint]]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [theRequest setHTTPMethod:method];
    [theRequest setValue:_apiKey forHTTPHeaderField:@"X-API-Key"];
    
    serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                       returningResponse:&serverResponse error:&myError];
    
    if (myError)
        return nil;
    
    id json = [NSJSONSerialization JSONObjectWithData:serverData options:
               NSJSONReadingMutableContainers error:&myError];
    return json;
}

- (id)sendGetRequestToEndpoint:(NSString *)endpoint parameters:(NSDictionary *)parameters
{
    return [self sendRequestToEndpoint:endpoint method:@"GET" parameters:parameters];
}

- (id)sendPostRequestToEndpoint:(NSString *)endpoint parameters:(NSDictionary *)parameters
{
    return [self sendRequestToEndpoint:endpoint method:@"POST" parameters:parameters];
}

- (bool)ping
{
    id json = [self sendGetRequestToEndpoint:@"/rest/system/ping" parameters:nil];
    
	if ([[json objectForKey:@"ping"] isEqualToString:@"pong"])
		return true;
	return false;
}

- (id)getUptime
{
    id json = [self sendGetRequestToEndpoint:@"/rest/system/status" parameters:nil];
    return [json objectForKey:@"uptime"];
}

- (id)getMyID {
    id json = [self sendGetRequestToEndpoint:@"/rest/system/status" parameters:nil];
    return [json objectForKey:@"myID"];
}

- (NSDictionary *)getConfig
{
    return [self sendGetRequestToEndpoint:@"/rest/system/config" parameters:nil];
}

- (id)getFolders
{
    return [[self getConfig] objectForKey:@"folders"];
}

- (id)getDevices
{
    return [[self getConfig] objectForKey:@"devices"];
}

- (void)pauseAllDevices
{
    [self sendPostRequestToEndpoint:@"/rest/system/pause" parameters:nil];
}

- (void)resumeAllDevices
{
    [self sendPostRequestToEndpoint:@"/rest/system/resume" parameters:nil];
}

- (void)rescanAll
{
    [self sendPostRequestToEndpoint:@"/rest/db/scan" parameters:nil];
}

- (BOOL)loadConfigurationFromXML
{
    NSError* error;
    NSURL *supURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                           inDomain:NSUserDomainMask
                                                  appropriateForURL:nil
                                                             create:NO
                                                              error:&error];
    NSURL* configUrl = [supURL URLByAppendingPathComponent:@"Syncthing/config.xml"];
    _parsing = [[NSMutableArray alloc] init];
    _configParser = [[NSXMLParser alloc] initWithContentsOfURL:configUrl];
    [_configParser setDelegate:self];
    return [_configParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    [_parsing addObject:elementName];
    NSString *keyPath = [_parsing componentsJoinedByString:@"."];
    
    if ([keyPath isEqualToString:@"configuration.gui"]) {
        if ([[[attributeDict objectForKey:@"tls"] lowercaseString] isEqualToString:@"true"]) {
            _URI = @"https://";
        } else {
            _URI = @"http://";
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [_parsing removeLastObject];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *keyPath = [_parsing componentsJoinedByString:@"."];
    
    if ([keyPath isEqualToString:@"configuration.gui.apikey"]) {
        _apiKey = string;
    } else if  ([keyPath isEqualToString:@"configuration.gui.address"]) {
        _URI = [_URI stringByAppendingString:string];
    }
}

@end
