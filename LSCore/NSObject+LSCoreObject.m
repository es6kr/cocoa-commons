//
//  NSObject+LSObject.m
//
//

#import <objc/runtime.h>
#import "NSObject+LSCoreObject.h"

@implementation NSObject(LSCoreObject)

+ (BOOL)addMethod:(Method)method forSelector:(SEL)sel {
    return class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
}

+ (Method)classMethod:(SEL)sel {
    return class_getClassMethod(self, sel);
}

+ (Class)createSubclass:(NSString *)name {
    Class class = objc_allocateClassPair(self, [name cStringUsingEncoding:NSUTF8StringEncoding], 0);
    objc_registerClassPair(class);
    return class;
}

+ (void)exchangeClassMethod:(SEL)sel1 method:(SEL)sel2 {
    method_exchangeImplementations(class_getClassMethod(self, sel1), class_getClassMethod(self, sel2));
}

+ (void)exchangeInstanceMethod:(SEL)sel1 method:(SEL)sel2 {
    Method method1 = class_getInstanceMethod(self, sel1);
    Method method2 = class_getInstanceMethod(self, sel2);
#ifdef DEBUG
    if( [self addMethod:method2 forSelector:sel1] ){
        [self addMethod:method1 forSelector:sel2];
        return;
    }
#endif
    method_exchangeImplementations(method1, method2);
}

+ (Method)instanceMethod:(SEL)sel {
    return class_getInstanceMethod(self, sel);
}

+ (NSInvocation *)invocationForInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    SEL newSel = NSSelectorFromString(selName);
    [self addMethod:[self instanceMethod:sel] forSelector:newSel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:sel]];
    [invocation setSelector:newSel];
    return invocation;
}

- (BOOL)boolValueForKey:(NSString *)key {
	return [self boolValueForKey:key defValue:NO];
}

- (BOOL)boolValueForKey:(NSString *)key defValue:(BOOL)def {
    id value = self[key];
    if( [value isKindOfClass:[NSNumber class]] ){
        return [value boolValue];
    }
    return def;
}

- (NSInteger)integerValueForKey:(NSString *)key {
    return [self integerValueForKey:key defValue:0];
}

- (NSInteger)integerValueForKey:(NSString *)key defValue:(int)def {
    id value = self[key];
    if( !value || [value isKindOfClass:[NSNull class]] ){
        return def;
    }
    return [value integerValue];
}

- (long long)longLongValueForKey:(id)key {
    return [self longLongValueForKey:key defValue:0];
}

- (long long)longLongValueForKey:(id)key defValue:(long long)def {
    id value = self[key];
    if( !value || [value isKindOfClass:[NSNull class]] ){
        return def;
    }
    return [value longLongValue];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self valueForKey:[key description]];
}

- (Class)setClass:(Class)cls {
    return object_setClass(self, cls);
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
    [self setValue:obj forKey:[key description]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"%@[%@] = %@", NSStringFromClass([self class]), key, value);
    objc_setAssociatedObject(self, NSSelectorFromString(key), value, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)stringValueForKey:(NSString *)key {
    return [[self valueForKey:key] stringValue];
}

- (id)valueForUndefinedKey:(NSString *)key {
    SEL sel = NSSelectorFromString(key);
    id value = objc_getAssociatedObject(self, sel);
#ifdef DEBUG
    if(!value){
//        NSLog(@"valueForUndefinedKey: %@", key);
    }
#endif
    return value;
}

@end
