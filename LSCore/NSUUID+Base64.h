//
//  NSUUID+Base64.h
//
//

@interface NSUUID (Base64)

- (instancetype)initWithBase64String:(NSString*)string withPadding:(BOOL)padding;
- (NSString*)base64EncodedString;

@end
