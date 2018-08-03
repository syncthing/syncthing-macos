#import "XGSyncthing.h"
#import "LocalhostTLSDelegate.h"

// How long we wait for one event poll
#define EVENT_TIMEOUT 60.0

@interface XGSyncthing()

@property (nonatomic, strong) NSXMLParser *configParser;
@property (nonatomic, strong) NSMutableArray<NSString *> *parsing;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation XGSyncthing {}

@synthesize URI = _URI;
@synthesize ApiKey = _apiKey;

- (id)sendRequestToEndpoint:(NSString *)endpoint method:(NSString *)method parameters:(NSDictionary *)parameters
{
    if (self.session == nil) {
        // Lazy create a reasonable URLSession
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:[[LocalhostTLSDelegate alloc] init] delegateQueue:nil];
    }

    // Create the URL from base, endpoint and params.
    NSURLComponents *comps = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@%@", _URI, endpoint]];
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in parameters) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@", parameters[key]]]];
    }
    comps.queryItems = queryItems;

    NSMutableURLRequest *theRequest = [NSMutableURLRequest
                                       requestWithURL:[comps URL]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

    [theRequest setHTTPMethod:method];
    [theRequest setValue:_apiKey forHTTPHeaderField:@"X-API-Key"];
    [theRequest setTimeoutInterval:EVENT_TIMEOUT + 5.0]; // slightly more than the Syncthing event timeout

    __block id result = nil;
    dispatch_semaphore_t done = dispatch_semaphore_create(0);

    NSURLSessionTask *task = [self.session dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            dispatch_semaphore_signal(done);
            return;
        }
        result = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error];
        dispatch_semaphore_signal(done);
    }];
    [task resume];

    dispatch_semaphore_wait(done, DISPATCH_TIME_FOREVER);
    return result;
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

- (id)getEventsSince:(long)since
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (since > 0) {
        // Get events since the last once seen, waiting at most EVENT_TIMEOUT s.
        [params setValue:[NSNumber numberWithLong:since] forKey:@"since"];
        [params setValue:[NSNumber numberWithFloat:EVENT_TIMEOUT] forKey:@"timeout"];
    }
    else {
        // Get the last event, whatever it is.
        [params setValue:[NSNumber numberWithInt:1] forKey:@"limit"];
    }
    // TODO(jb): We should specify which events we're interested in,
    // exactly. Both to avoid the firehose and also to avoid Syncthing
    // changing stuff underneath our feet in the future.
    return [self sendGetRequestToEndpoint:@"/rest/events" parameters:params];
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
