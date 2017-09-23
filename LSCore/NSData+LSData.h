//
//  NSData+LSData.h
//
//

@interface NSData (LSData)

- (NSString*)base64EncodedStringWithNoPadding;
- (NSString*)base64EncodedStringWithURLSafe;
- (id)JSONObject;
- (NSString *)UTF8String;

@end


@interface NSObject (LSData)

- (NSData *)JSONData;

@end
