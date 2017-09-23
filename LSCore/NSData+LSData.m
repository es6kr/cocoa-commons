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

- (id)JSONObject {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    if(error){
        NSLog(@"JSON reading error: %@", error);
    }
    return jsonObject;
}

- (NSString *)UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end


@implementation NSObject (LSData)

- (NSData *)JSONData {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if(error){
        NSLog(@"JSON writing error: %@", error);
    }
    return data;
}

@end
