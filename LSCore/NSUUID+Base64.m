//
//  NSUUID+Base64.m
//
//

#import "LSFoundation.h"

@implementation NSUUID (Base64)

- (instancetype)initWithBase64String:(NSString*)string withPadding:(BOOL)padding
{
    if (padding == NO) {
        string = [string stringByPaddingToLength:(string.length + (string.length % 4)) withString:@"=" startingAtIndex:0];
    }

    NSData* d = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    uuid_t bytes;
    [d getBytes:bytes length:d.length];
    return [self initWithUUIDBytes:bytes];
}

- (NSString*)base64EncodedString {
    uuid_t bytes;
    [self getUUIDBytes:bytes];
    return [[NSData dataWithBytes:bytes length:sizeof(uuid_t)] base64EncodedStringWithURLSafe];
}

@end
