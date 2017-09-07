//
//  NSData+LSData.m
//
//

#import "NSData+LSData.h"

@implementation NSData (LSData)

- (NSString*)base64EncodedStringWithNoPadding {
    return [[self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
}

- (NSString*)base64EncodedStringWithURLSafe {
    NSString *string = [self base64EncodedStringWithNoPadding];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return string;
}

@end
