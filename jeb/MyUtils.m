#import "MyUtils.h"

@implementation MyUtils

- (MyUtils*)init;
{
    return [super init];
}

- (char*)getPath:(NSString*)name :(NSString*)type :(NSString*)folder;
{
  NSString* filepath = [[NSBundle mainBundle] pathForResource:name ofType:type inDirectory:folder];
	char* path = [filepath cStringUsingEncoding:NSASCIIStringEncoding];
	return path;
}

@end
