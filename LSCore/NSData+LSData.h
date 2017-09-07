//
//  NSData+LSData.h
//
//

@interface NSData (LSData)

- (NSString*)base64EncodedStringWithNoPadding;
- (NSString*)base64EncodedStringWithURLSafe;

@end
