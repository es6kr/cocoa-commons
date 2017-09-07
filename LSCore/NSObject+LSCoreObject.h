//
//  NSObject+LSObject.h
//
//

#import "LSFoundation.h"

typedef struct objc_method *Method;

@interface NSObject (LSCoreObject)

+ (BOOL)addMethod:(Method)method forSelector:(SEL)sel;
+ (Method)classMethod:(SEL)sel;
+ (Class)createSubclass:(NSString *)name;
+ (void)exchangeClassMethod:(SEL)sel1 method:(SEL)sel2;
+ (void)exchangeInstanceMethod:(SEL)sel1 method:(SEL)sel2;
+ (Method)instanceMethod:(SEL)sel;
+ (NSInvocation *)invocationForInstanceMethod:(SEL)sel;

- (BOOL)boolValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key defValue:(BOOL)def;
- (NSInteger)integerValueForKey:(NSString *)key;
- (NSInteger)integerValueForKey:(NSString *)key defValue:(int)def;
- (long long)longLongValueForKey:(id)key;
- (long long)longLongValueForKey:(id)key defValue:(long long)def;
- (NSString *)stringValueForKey:(NSString *)key;

- (id)objectForKeyedSubscript:(id)key;
- (Class)setClass:(Class)cls;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
