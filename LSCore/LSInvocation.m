//
//  LSInvocation.m
//
//

#import <objc/runtime.h>
#import "LSInvocation.h"

@implementation LSInvocation

- (id)initWithObject:(id)object selector:(SEL)sel {
    self = [self init];
    Method method = [[object class] instanceMethod:sel];
    return [self initWithObject:object method:[object methodForSelector:sel] types:[NSString stringWithUTF8String:method_getTypeEncoding(method)]];
}

- (id)initWithObject:(id)object method:(IMP)imp types:(NSString *)types {
    self = [self init];
    _object = object;
    _imp = imp;
    _types = types;
    return self;
}

@end
