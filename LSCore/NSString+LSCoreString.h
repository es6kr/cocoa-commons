//
//  NSString+LSCoreString.h
//
//

@interface NSString (LSCoreString)

- (NSString *)escape;
- (BOOL)isBlank;
- (id)JSONObject;
- (NSString *)localize;
+ (NSString *)localizedStringForKeyAndArguments:(NSString *)key, ...;
- (BOOL)matchesWithPattern:(NSString *)expression;
- (NSString *)replaceAll:(NSString *)pattern withString:(NSString *)replacement;
+ (NSString *)stringWithFormat:(NSString *)format arguments:(va_list)argList;
- (NSString *)trim;
- (NSString *)unescape;

@end
