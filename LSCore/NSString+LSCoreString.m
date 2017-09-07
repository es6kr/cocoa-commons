//
//  NSString+LSCoreString.m
//
//


#import "NSString+LSCoreString.h"
#import <uiKit/NSAttributedString.h>
#import <Foundation/NSAttributedString.h>


@implementation NSString(LSCoreString)

- (NSString *)escape {
//    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
}

- (BOOL)isBlank {
    return [self trim].length == 0;
}

- (NSString *)localize {
    return NSLocalizedString(self, nil);
}

+ (NSString *)localizedStringForKeyAndArguments:(NSString *)key, ...{
    va_list vlist;
    va_start(vlist, key);
    @try{
        return [NSString stringWithFormat:[[NSString stringWithFormat:[[key localize] stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"] arguments:vlist] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] arguments:vlist];
    }
    @finally{
        va_end(vlist);
    }
}

- (BOOL)matchesWithPattern:(NSString *)pattern {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex numberOfMatchesInString:self options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, self.length)];
}

- (NSString *)replaceAll:(NSString *)pattern withString:(NSString *)replacement {
//    NSString *result = self;
//    while(YES){
//        NSRange match = [result rangeOfString:pattern options:NSRegularExpressionSearch];
//        if( match.location == NSNotFound) break;
//        result = [result stringByReplacingCharactersInRange:match withString:replacement];
//    }
//    return result;
    return [self stringByReplacingOccurrencesOfString:pattern withString:replacement options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
}

+ (NSString *)stringWithFormat:(NSString *)format arguments:(va_list)argList {
    return [[NSString alloc] initWithFormat:format arguments:argList];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)unescape {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

