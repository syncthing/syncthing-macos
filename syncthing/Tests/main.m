#import <Foundation/Foundation.h>
#import <XGSyncthing.h>

int main (int argc, const char * argv[])
{
    XGSyncthing *st = [[XGSyncthing alloc] init];

    [st setURI:@"http://localhost:8384"];
    [st setApiKey:@"83GgPHZcHFSi-GEj03mv8tEix6WUXW-K"];
    
    if ([st ping])
        NSLog(@"Syncthing OK!");
    else
        NSLog(@"Syncthing borken!");
    
    /* Configured folder ids */
    for (id dir in [st getFolders]) {
        NSLog(@"id: %@", [dir objectForKey:@"id"]);
    }

    return 0;
}